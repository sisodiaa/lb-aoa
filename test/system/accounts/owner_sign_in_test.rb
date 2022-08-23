require "application_system_test_case"

module Accounts
  class OwnerSignInTest < ApplicationSystemTestCase
    test "signing in" do
      visit new_owner_session_url

      within("form#new_owner") do
        fill_in "owner_email", with: "owner_two@example.com"
        fill_in "owner_password", with: "password"
        click_on "Sign In"
      end

      assert_selector "[role='toast']", text: "Signed in successfully."
    end

    test "failed signing in" do
      visit new_owner_session_url

      within("form#new_owner") do
        fill_in "owner_email", with: "owner_two@example.com"
        fill_in "owner_password", with: "dassworp"
        click_on "Sign In"
      end

      assert_selector "[role='toast']", text: "Invalid Email or password"
    end
  end
end
