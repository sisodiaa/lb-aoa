require "application_system_test_case"

module Accounts
  class OwnerProfileTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
      login_as @confirmed_linked_owner, scope: :owner
    end

    teardown do
      logout :owner
      @confirmed_linked_owner = nil
      Warden.test_reset!
    end

    test "successfully updating a profile" do
      visit edit_owners_profile_url

      within "form#edit_profile" do
        fill_in "profile_last_name", with: "User"
        click_on "Update Profile"
      end

      assert_text "Welcome Second Dummy User"
      assert_selector "[role='toast']", text: "Your profile was successfully updated."
    end

    test "show error messages if profile is not updated" do
      visit edit_owners_profile_url

      within "form#edit_profile" do
        fill_in "profile_last_name", with: ""
        click_on "Update Profile"
      end

      assert_selector "#error_explanation li", text: "Last name can't be blank"
    end
  end
end
