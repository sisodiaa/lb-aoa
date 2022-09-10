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

        click_on "Memberships"

        assert_selector "li", text: "Under review", visible: true
      end
    end

    test "appoving a membership" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        assert_selector "#membership-details"
        assert_selector "#under_review_memberships"

        within "#membership-details" do
          assert_no_selector "form"
          assert_selector "select[disabled]"
          assert_selector "input[type='text'][disabled]"
        end

        within "#under_review_memberships" do
          assert_selector ".membership", count: 2

          click_on "View Details and Manage", match: :first
        end

        within "#membership-details" do
          assert_selector "form"
          assert_selector "select#membership_transition"
          assert_selector "input#membership_remark"

          within "form" do
            select "Approve", from: "membership_transition"
            click_on "Update Membership"
          end
        end

        within "#under_review_memberships" do
          assert_selector ".membership", count: 1
        end
      end

      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "rejecting a membership" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        within "#under_review_memberships" do
          assert_selector ".membership", count: 2

          click_on "View Details and Manage", match: :first
        end

        within "#membership-details" do
          within "form" do
            select "Reject", from: "membership_transition"
            fill_in "membership_remark", with: "Purchase date is not verifiable"
            click_on "Update Membership"
          end
        end

        within "#under_review_memberships" do
          assert_selector ".membership", count: 1
        end
      end

      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "show error if remark is not given while rejecting a membership" do
      visit management_memberships_path(status: "under_review")

      within "#main" do
        within "#under_review_memberships" do
          click_on "View Details and Manage", match: :first
        end

        within "#membership-details" do
          within "form" do
            select "Reject", from: "membership_transition"
            click_on "Update Membership"

            assert_selector "#error_explanation li", text: "Remark can't be blank"
          end
        end

        within "#under_review_memberships" do
          assert_selector ".membership", count: 2
        end
      end
    end

    test "archiving a membership" do
      visit management_memberships_path(status: "approved")

      within "#main" do
        within "#approved_memberships" do
          assert_selector ".membership", count: 3

          click_on "View Details and Manage", match: :first
        end

        within "#membership-details" do
          within "form" do
            select "Archive", from: "membership_transition"
            click_on "Update Membership"
          end
        end

        within "#approved_memberships" do
          assert_selector ".membership", count: 2
        end
      end

      assert_selector "[role='toast']", text: "Membership state was successfully updated."
    end

    test "do not show transition controls for Rejected membership records" do
      visit management_memberships_path(status: "rejected")
      within "#main" do
        within "#membership-details" do
          assert_no_selector "select"
        end

        within "#rejected_memberships" do
          click_on "View Details and Manage", match: :first
        end

        within "#membership-details" do
          assert_no_selector "select"
        end
      end
    end

    test "do not show transition controls for Archived membership records" do
      visit management_memberships_path(status: "archived")
      within "#main" do
        within "#membership-details" do
          assert_no_selector "select"
        end

        within "#archived_memberships" do
          click_on "View Details and Manage", match: :first
        end

        within "#membership-details" do
          assert_no_selector "select"
        end
      end
    end
  end
end
