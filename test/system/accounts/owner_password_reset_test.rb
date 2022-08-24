require "application_system_test_case"

module Accounts
  class OwnerPasswordResetTest < ApplicationSystemTestCase
    setup do
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
    end

    teardown do
      @confirmed_linked_owner = nil
    end

    test "send password reset link" do
      visit new_owner_password_url

      within("form#new_owner") do
        fill_in "owner_email", with: @confirmed_linked_owner.email
        click_on "Send me reset password instructions"
      end

      assert_selector(
        "[role='toast']",
        text: "You will receive an email with instructions on how to reset " \
          "your password in a few minutes."
      )
    end

    test "show error message if email is not found" do
      visit new_owner_password_url

      within("form#new_owner") do
        fill_in "owner_email", with: "bogus_owner@example.com"
        click_on "Send me reset password instructions"
      end

      assert_selector "#error_explanation li", text: "Email not found"
    end

    test "show error message if email is not given" do
      visit new_owner_password_url

      within("form#new_owner") do
        fill_in "owner_email", with: ""
        click_on "Send me reset password instructions"
      end

      assert_selector "#error_explanation li", text: "Email can't be blank"
    end

    test "changes password of an owner" do
      visit edit_owner_password_url(reset_password_token: reset_password_token)

      within("form#new_owner") do
        fill_in "owner_password", with: "dassworp"
        fill_in "owner_password_confirmation", with: "dassworp"
        click_on "Change my password"
      end

      assert_selector(
        "[role='toast']",
        text: "Your password has been changed successfully. You are now signed in."
      )
    end

    test "password confirmation does not match password" do
      visit edit_owner_password_url(reset_password_token: reset_password_token)

      within("form#new_owner") do
        fill_in "owner_password", with: "dassworp"
        fill_in "owner_password_confirmation", with: "dasswworp"
        click_on "Change my password"
      end

      assert_selector(
        "#error_explanation li",
        text: "Password confirmation doesn't match Password"
      )
    end

    test "reset_password_token is invalid" do
      visit edit_owner_password_url(reset_password_token: "abc123")

      within("form#new_owner") do
        fill_in "owner_password", with: "dassworp"
        fill_in "owner_password_confirmation", with: "dassworp"
        click_on "Change my password"
      end

      assert_selector "#error_explanation li", text: "Reset password token is invalid"
    end

    private

    def reset_password_token
      devise_token_generator(Owner, :reset_password_token) do |raw, hashed|
        @confirmed_linked_owner.reset_password_token = hashed
        @confirmed_linked_owner.reset_password_sent_at = Time.now.utc
        @confirmed_linked_owner.save

        raw
      end
    end
  end
end
