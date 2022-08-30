require "application_system_test_case"

module Accounts
  class OwnerHomepageTest < ApplicationSystemTestCase
    test "check presence of sign up button" do
      visit root_url

      assert_selector 'a[href="/owners/sign_up"]', text: "Sign Up"
    end

    test "that toast shows the error message if nothing is entered" do
      visit root_url

      click_on "Sign In"
      assert_selector "[role='toast']", text: "You need to sign in or sign up before continuing."
      assert_equal root_path, current_path
    end

    test "that toast shows the error message if email and/or password combination is not correct" do
      visit root_url

      within("form#new_owner") do
        fill_in "owner_email", with: "owner_two@example.com"
        fill_in "owner_password", with: "dassworp"
        click_on "Sign In"
      end

      assert_selector "[role='toast']", text: "Invalid Email or password"
      assert_equal root_path, current_path
    end

    test "that owner can log in via homepage" do
      visit root_url

      within("form#new_owner") do
        fill_in "owner_email", with: "owner_two@example.com"
        fill_in "owner_password", with: "password"
        click_on "Sign In"
      end

      assert_selector "[role='toast']", text: "Signed in successfully."
      assert_equal owner_root_path, current_path
    end
  end
end
