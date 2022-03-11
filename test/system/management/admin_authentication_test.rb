require "application_system_test_case"

module Management
  class AdminAuthenticationTest < ApplicationSystemTestCase
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test "admin login and logout" do
      visit management_root_url

      assert_selector "h3", text: "Sign in to Management Dashboard"

      fill_in "admin_email", with: @confirmed_board_admin.email
      fill_in "admin_password", with: "password"
      click_on "Sign In"

      assert_selector :css, "[role='toast']", text: "Signed in successfully."
      assert_selector "h5", text: "Posts"
      assert_selector "li span", text: "#{Post.draft.count} Drafts"
      assert_selector "li span", text: "#{Post.published.count} Published Posts"

      within "nav" do
        click_link "Sign out"
      end

      assert_selector :css, "[role='toast']", text: "Signed out successfully."
    end
  end
end
