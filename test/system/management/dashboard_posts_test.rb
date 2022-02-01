require "application_system_test_case"

module Management
  class DashboardPostsTest < ApplicationSystemTestCase
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

    test "dashboard for posts" do
      visit management_dashboard_path

      within("#drafts") do
        assert_selector ".draft", count: 5
        assert_selector "p", text: "1 to 5 of 12 draft posts"
        click_link "Next"

        assert_selector ".draft", count: 5
        assert_selector "p", text: "6 to 10 of 12 draft posts"
        click_link "Next"

        assert_selector ".draft", count: 2
        assert_selector "p", text: "11 to 12 of 12 draft posts"
      end

      within("#published_posts") do
        assert_selector ".published_post", count: 5
        assert_selector "p", text: "1 to 5 of 9 published posts"
        click_link "Next"

        assert_selector ".published_post", count: 4
        assert_selector "p", text: "6 to 9 of 9 published posts"
      end
    end

    test "delete button is working" do
      # this is not the correct flow,
      # this test is just to check delete works
      visit management_dashboard_path

      within("#drafts") do
        assert_selector ".draft", count: 5

        page.accept_confirm do
          click_on "Delete", match: :first
        end

        assert_selector ".draft", count: 4
      end
    end
  end
end
