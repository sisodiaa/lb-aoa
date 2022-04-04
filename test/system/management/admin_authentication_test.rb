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
      assert_selector "h5", text: "Post"
      assert_selector "h5", text: "Category"

      within "nav" do
        click_link "Sign out"
      end

      assert_selector :css, "[role='toast']", text: "Signed out successfully."
    end

    test "changing password" do
      login_as @confirmed_board_admin, scope: :admin

      visit edit_admin_registration_path

      within("form.edit_admin") do
        click_on "Update"
        assert_selector "#error_explanation li", text: "Current password can't be blank"

        fill_in "admin_password", with: "dassworp"
        fill_in "admin_password_confirmation", with: "dassworp"
        fill_in "admin_current_password", with: "password"
        click_on "Update"
      end

      assert_selector "[role='toast']", text: "Your account has been updated successfully."

      logout :admin
    end
  end
end
