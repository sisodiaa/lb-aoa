require "application_system_test_case"

module Management
  class DashboardTendersTest < ApplicationSystemTestCase
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

    test "dashboard for tenders" do
      visit management_dashboard_path

      within("#tenders-component") do
        click_link "Show Tender Notices"

        within("#draft_tenders") do
          assert_selector ".tender", count: 2
          assert_selector "p", text: "1 to 2 of 2 draft tenders"
        end
      end
    end

    test "delete button is working" do
      skip
      # this is not the correct flow,
      # this test is just to check delete works
      visit management_dashboard_path

      within("#posts-component") do
        click_link "Show Posts"

        within("#drafts") do
          assert_selector ".draft", count: 5

          page.accept_confirm do
            click_on "Delete", match: :first
          end

          assert_selector ".draft", count: 4
        end
      end

      assert_selector :css, "[role='toast']", text: "Post was successfully destroyed."
    end
  end
end
