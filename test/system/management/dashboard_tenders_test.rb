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
      visit management_dashboard_path

      within("#tenders-component") do
        click_link "Show Tender Notices"

        within("#draft_tenders") do
          assert_selector ".tender", count: 2
          assert_selector "p", text: "1 to 2 of 2 draft tenders"

          page.accept_confirm do
            click_on "Delete", match: :first
          end

          assert_selector ".tender", count: 1
          assert_selector "p", text: "1 to 1 of 1 draft tenders"
        end
      end

      assert_selector :css, "[role='toast']", text: "Tender was successfully destroyed."
    end
  end
end
