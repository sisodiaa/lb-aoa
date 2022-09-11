require "application_system_test_case"

module Accounts
  class OwnerDashboardNoticeTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
    end

    teardown do
      Warden.test_reset!
    end

    test "show notice if account is unlinked" do
      confirmed_unlinked_owner = owners(:confirmed_unlinked_owner)
      login_as confirmed_unlinked_owner, scope: :owner

      visit owners_dashboard_url

      assert_selector "#account-linking-notice"
      assert_no_selector "#profile-notice"

      logout :owner
    end

    test "show notice if profile is not complete" do
      owner_with_incomplete_profile = owners(:owner_seven)
      login_as owner_with_incomplete_profile, scope: :owner

      visit owners_dashboard_url

      assert_no_selector "#account-linking-notice"
      assert_selector "#profile-notice"

      logout :owner
    end
  end
end
