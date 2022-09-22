require "application_system_test_case"

module Accounts
  class OwnerSignInTest < ApplicationSystemTestCase
    test "signing in and signing out" do
      visit new_owner_session_url

      within("form#new_owner") do
        fill_in "owner_email", with: "owner_two@example.com"
        fill_in "owner_password", with: "password"
        click_on "Sign In"
      end

      assert_selector "[role='toast']", text: "Signed in successfully."
      assert_equal owner_root_path, current_path

      within "nav" do
        click_on "Sign out"
      end

      assert_selector "[role='toast']", text: "Signed out successfully."
      assert_equal root_path, current_path
    end

    test "failed signing in" do
      visit new_owner_session_url

      within("form#new_owner") do
        fill_in "owner_email", with: "owner_two@example.com"
        fill_in "owner_password", with: "dassworp"
        click_on "Sign In"
      end

      assert_selector "[role='toast']", text: "Invalid Email or password"
      assert_equal new_owner_session_path, current_path
    end
  end
end
