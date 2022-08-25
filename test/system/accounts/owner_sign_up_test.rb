require "application_system_test_case"

module Accounts
  class OwnerSignUpTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
    end

    teardown do
      @confirmed_linked_owner = nil
      Warden.test_reset!
    end

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
        assert_selector(
          "#error_explanation li",
          text: "Profile first name can't be blank"
        )
        assert_selector(
          "#error_explanation li",
          text: "Profile last name can't be blank"
        )
      end
    end

    test "create a new user" do
      visit new_owner_registration_url

      within("form#new_owner") do
        fill_in "owner_email", with: "new_owner@example.com"
        fill_in "owner_profile_attributes_first_name", with: "New"
        fill_in "owner_profile_attributes_last_name", with: "Owner"
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

    test "that current password is required for committing any changes" do
      authenticated_owner do
        visit edit_owner_registration_url
        click_on "Update"

        assert_selector "#error_explanation li", text: "Current password can't be blank"
      end
    end

    test "to change password of an account" do
      authenticated_owner do
        visit edit_owner_registration_url

        within("form#edit_owner") do
          fill_in "owner_password", with: "dassworp"
          fill_in "owner_password_confirmation", with: "dassworp"
          fill_in "owner_current_password", with: "password"
          click_on "Update"
        end

        assert_selector "[role='toast']", text: "Your account has been updated successfully."
      end
    end

    private

    def authenticated_owner
      login_as @confirmed_linked_owner, scope: :owner
      yield if block_given?
      logout :owner
    end
  end
end
