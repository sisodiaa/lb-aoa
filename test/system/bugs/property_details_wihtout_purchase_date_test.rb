require "application_system_test_case"

module Bugs
  class PropertyDetailsWithoutPurchaseDateTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
    end

    teardown do
      Warden.test_reset!
    end

    test "that property details will be displayed even if there is no purchased_on date" do
      owner = owners(:owner_seven)

      login_as owner, scope: :owner
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Properties"
      end

      within "#dashboard-properties" do
        within :xpath, "//table/tbody/tr[1]" do
          click_on "Details"
        end
      end

      within "#dashboard-property" do
        assert_selector :xpath, "//tr[3]/th", text: "Property Registered"
      end

      logout :owner
    end
  end
end
