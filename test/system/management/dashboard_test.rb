require "application_system_test_case"

module Management
  class DashboardTest < ApplicationSystemTestCase
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

    test "dashboard for admin" do
      visit management_dashboard_path

      assert_selector "h5", text: "Posts"
      assert_selector "li span", text: "#{Post.draft.count} Drafts"
      assert_selector "li span", text: "#{Post.published.count} Published Posts"
    end
  end
end
