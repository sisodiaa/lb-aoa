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
  end
end
