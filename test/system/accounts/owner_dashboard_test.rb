require "application_system_test_case"

module Accounts
  class OwnerDashboardTest < ApplicationSystemTestCase
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

    test "that account and profile information is displayed through tabbed interface" do
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Account"
      end

      assert_selector "#dashboard-account"
      assert_no_selector "#dashboard-profile"

      within "#dashboard-account" do
        assert_selector :xpath, "//table/tbody/tr/td", text: "owner_two@example.com"
      end

      within "#dashboard-tabs" do
        click_on "Profile"
      end

      assert_no_selector "#dashboard-account"
      assert_selector "#dashboard-profile"

      within "#dashboard-profile" do
        assert_selector :xpath, "//table/tbody/tr[1]/td", text: "Second"
        assert_selector :xpath, "//table/tbody/tr[2]/td", text: "Dummy"
        assert_selector :xpath, "//table/tbody/tr[3]/td", text: "Owner"
        assert_selector :xpath, "//table/tbody/tr[4]/td", text: "+91-9797979797"
      end
    end
  end
end
