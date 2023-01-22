require "application_system_test_case"

module Bugs
  class PropertyEditFormWithoutPurchaseDateTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
    end

    teardown do
      Warden.test_reset!
    end

    test "that property edit form will render in absence of purchased_on date" do
      owner = owners(:owner_seven)
      property = owner.properties.order("purchased_on ASC").first

      login_as owner, scope: :owner
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Properties"
      end

      within "#dashboard-properties" do
        within :xpath, "//table/tbody/tr[1]" do
          click_on "Edit"
        end
      end

      assert_selector "form#property_#{property.id}"

      logout :owner
    end
  end
end
