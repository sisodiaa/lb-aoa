require "application_system_test_case"

module Accounts
  class OwnerSignUpTest < ApplicationSystemTestCase
    test "show error messages for blank fields" do
      visit new_owner_registration_url

      within("form#new_owner") do
        click_on "Sign Up"

        assert_selector(
          "#error_explanation li",
          text: "Email can't be blank"
        )
        assert_selector(
          "#error_explanation li",
          text: "Password can't be blank"
        )
      end
    end

    test "create a new user" do
      visit new_owner_registration_url

      within("form#new_owner") do
        fill_in "owner_email", with: "new_owner@example.com"
        fill_in "owner_password", with: "password"
        fill_in "owner_password_confirmation", with: "password"
        click_on "Sign Up"
      end

      assert_selector(
        "[role='toast']",
        text: "A message with a confirmation link has been sent to your email address. " \
          "Please follow the link to activate your account."
      )
    end
  end
end
