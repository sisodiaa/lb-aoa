require "application_system_test_case"

module Accounts
  class OwnerAccountUnlockTest < ApplicationSystemTestCase
    setup do
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
    end

    teardown do
      @confirmed_linked_owner = nil
    end

    test "send account unlock link" do
      @confirmed_linked_owner.lock_access!
      visit new_owner_unlock_url

      within("form#new_owner") do
        fill_in "owner_email", with: @confirmed_linked_owner.email
        click_on "Send unlock instructions"
      end

      assert_selector(
        "[role='toast']",
        text: "You will receive an email with instructions for how to unlock " \
          "your account in a few minutes."
      )
    end

    test "show error message if email was not locked" do
      visit new_owner_unlock_url

      within("form#new_owner") do
        fill_in "owner_email", with: @confirmed_linked_owner.email
        click_on "Send unlock instructions"
      end

      assert_selector "#error_explanation li", text: "Email was not locked"
    end

    test "show error message if email is not found" do
      visit new_owner_unlock_url

      within("form#new_owner") do
        fill_in "owner_email", with: "bogus_owner@example.com"
        click_on "Send unlock instructions"
      end

      assert_selector "#error_explanation li", text: "Email not found"
    end

    test "show error message if email is not given" do
      visit new_owner_unlock_url

      within("form#new_owner") do
        fill_in "owner_email", with: ""
        click_on "Send unlock instructions"
      end

      assert_selector "#error_explanation li", text: "Email can't be blank"
    end

    test "unlock a locked account" do
      visit owner_unlock_url(unlock_token: unlock_token)

      assert_selector(
        "[role='toast']",
        text: "Your account has been unlocked successfully. Please sign in to continue."
      )
    end

    test "unlock token is invalid" do
      visit owner_unlock_url(unlock_token: "abc123")

      assert_selector "#error_explanation li", text: "Unlock token is invalid"
    end

    private

    def unlock_token
      devise_token_generator(Owner, :unlock_token) do |raw, hashed|
        @confirmed_linked_owner.unlock_token = hashed
        @confirmed_linked_owner.locked_at = Time.now.utc - 2.hours
        @confirmed_linked_owner.save

        raw
      end
    end
  end
end
