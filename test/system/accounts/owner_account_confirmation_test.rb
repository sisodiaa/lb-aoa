require "application_system_test_case"

module Accounts
  class OwnerAccountConfirmationTest < ApplicationSystemTestCase
    setup do
      @unconfirmed_owner = owners(:unconfirmed_owner)
    end

    teardown do
      @unconfirmed_owner = nil
    end

    test "resend account confirmation link" do
      visit new_owner_confirmation_url

      within("form#new_owner") do
        fill_in "owner_email", with: @unconfirmed_owner.email
        click_on "Resend confirmation instructions"
      end

      assert_selector(
        "[role='toast']",
        text: "You will receive an email with instructions for how to confirm " \
        "your email address in a few minutes."
      )
    end

    test "show error message if email is not found" do
      visit new_owner_confirmation_url

      within("form#new_owner") do
        fill_in "owner_email", with: "bogus_owner@example.com"
        click_on "Resend confirmation instructions"
      end

      assert_selector "#error_explanation li", text: "Email not found"
    end

    test "show error message if email is not given" do
      visit new_owner_confirmation_url

      within("form#new_owner") do
        fill_in "owner_email", with: ""
        click_on "Resend confirmation instructions"
      end

      assert_selector "#error_explanation li", text: "Email can't be blank"
    end

    test "confirm an unconfirmed owner" do
      visit owner_confirmation_url(confirmation_token: confirmation_token)

      assert_selector(
        "[role='toast']",
        text: "Your email address has been successfully confirmed."
      )
    end

    test "confirmation token is invalid" do
      visit owner_confirmation_url(confirmation_token: "abc123")

      assert_selector "#error_explanation li", text: "Confirmation token is invalid"
    end

    private

    def confirmation_token
      devise_token_generator(Owner, :confirmation_token) do |raw, hashed|
        @unconfirmed_owner.confirmation_token = hashed
        @unconfirmed_owner.confirmation_sent_at = Time.now.utc
        @unconfirmed_owner.save

        raw
      end
    end
  end
end
