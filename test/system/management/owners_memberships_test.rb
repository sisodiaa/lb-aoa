require "application_system_test_case"

module Management
  class OwnersMembershipsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = nil
      Warden.test_reset!
    end

    test "that sidebar toggle works for Memberships" do
      visit management_dashboard_path

      within "aside" do
        assert_selector "li", text: "Under review", visible: false

        find("#memberships-details").click

        assert_selector "li", text: "Under review", visible: true
      end
    end

    test "appoving a membership" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        assert_selector "#under_review_memberships"

        within "#under_review_memberships" do
          assert_selector ".membership", count: 2

          click_on "View Details and Manage", match: :first
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(Membership.under_review.first, :details)}" do
          assert_selector "select#membership_transition"
          assert_selector "input#membership_remark"

          select "Approve", from: "membership_transition"
          click_on "Update Membership"
        end
      end

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 1
        end
      end

      assert_no_selector "turbo-frame#modal[complete]"
      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "rejecting a membership" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 2

          click_on "View Details and Manage", match: :first
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(Membership.under_review.first, :details)}" do
          assert_selector "#membership-details-fields"
          select "Reject", from: "membership_transition"
          fill_in "membership_remark", with: "Purchase date is not verifiable"
          click_on "Update Membership"
        end
      end

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 1
        end
      end

      assert_no_selector "turbo-frame#modal[complete]"
      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "show error if remark is not given while rejecting a membership" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        within "#under_review_memberships" do
          click_on "View Details and Manage", match: :first
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(Membership.under_review.first, :details)}" do
          select "Reject", from: "membership_transition"
          click_on "Update Membership"

          assert_selector "#error_explanation li", text: "Remark can't be blank"
        end
      end

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 2
        end
      end
    end

    test "archiving a membership" do
      membership = memberships(:membership_six)
      visit management_memberships_path(status: "approved")

      within "#main" do
        within "#approved_memberships" do
          assert_selector ".membership", count: 3

          within "div##{dom_id(membership)}" do
            click_on "View Details and Manage"
          end
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(membership, :details)}" do
          select "Archive", from: "membership_transition"
          click_on "Update Membership"
        end
      end

      within "#main" do
        within "#approved_memberships" do
          assert_selector ".membership", count: 2
        end
      end

      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "show error when archiving a membership if purchased date is not present" do
      membership = memberships(:membership_seven)
      visit management_memberships_path(status: "approved")

      within "#main" do
        within "#approved_memberships" do
          assert_selector ".membership", count: 3

          within "div##{dom_id(membership)}" do
            click_on "View Details and Manage"
          end
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(membership, :details)}" do
          select "Archive", from: "membership_transition"
          click_on "Update Membership"

          assert_selector "#error_explanation li", text: "Purchase date of the property is not present"
        end
      end
    end

    test "do not show transition controls for Rejected membership records" do
      visit management_memberships_path(status: "rejected")
      within "#main" do
        within "#rejected_memberships" do
          click_on "View Details and Manage", match: :first
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(Membership.rejected.first, :details)}" do
          assert_no_selector "select"
          assert_selector "h3", text: "Remark"
        end
      end
    end

    test "do not show transition controls for Archived membership records" do
      visit management_memberships_path(status: "archived")
      within "#main" do
        within "#archived_memberships" do
          click_on "View Details and Manage", match: :first
        end
      end

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(Membership.archived.first, :details)}" do
          assert_no_selector "select"
        end
      end
    end

    test "appoving a membership selected from owner's membership list" do
      owner = owners(:confirmed_linked_owner)

      visit management_owners_memberships_url(owner)

      assert_no_selector "turbo-frame#modal[complete]"

      within "#_memberships" do
        assert_selector ".membership", count: 3

        membership = memberships(:under_review_membership)
        within("div##{dom_id(membership)}") do
          click_on "View Details and Manage"
        end
      end

      assert_selector "turbo-frame#modal[complete]"

      within "#modal form" do
        select "Approve", from: "membership_transition"
        click_on "Update Membership"
      end

      within "#_memberships" do
        assert_selector ".membership", count: 3
      end

      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "appoving a membership selected from apartment's membership list" do
      apartment = apartments(:apartment_two)

      visit management_apartments_memberships_url(apartment)

      assert_no_selector "turbo-frame#modal[complete]"

      within "#_memberships" do
        assert_selector ".membership", count: 2

        click_on "View Details and Manage", match: :first
      end

      assert_selector "turbo-frame#modal[complete]"

      within "#modal form" do
        select "Approve", from: "membership_transition"
        click_on "Update Membership"
      end

      within "#_memberships" do
        assert_selector ".membership", count: 2
      end

      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "close the modal" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 2
          click_on "View Details and Manage", match: :first
        end
      end

      assert_selector "turbo-frame#modal[complete][src]"

      within "turbo-frame#modal[complete]" do
        within "form##{dom_id(Membership.under_review.first, :details)}" do
          click_on "Close"
        end
      end

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 2
        end
      end

      assert_no_selector "turbo-frame#modal[complete][src]"
    end
  end
end
