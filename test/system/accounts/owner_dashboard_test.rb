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

    test "that account, profile, and properties information is displayed through tabbed interface" do
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Account"
      end

      assert_selector "#dashboard-account"
      assert_no_selector "#dashboard-profile"
      assert_no_selector "#dashboard-properties"

      within "#dashboard-account" do
        assert_selector :xpath, "//table/tbody/tr/td", text: "owner_two@example.com"
        assert_selector :xpath, "//table/tbody/tr[2]/th/a", text: "Edit Account"
      end

      within "#dashboard-tabs" do
        click_on "Profile"
      end

      assert_no_selector "#dashboard-account"
      assert_selector "#dashboard-profile"
      assert_no_selector "#dashboard-properties"

      within "#dashboard-profile" do
        assert_selector :xpath, "//table/tbody/tr[1]/td", text: "Second"
        assert_selector :xpath, "//table/tbody/tr[2]/td", text: "Dummy"
        assert_selector :xpath, "//table/tbody/tr[3]/td", text: "Owner"
        assert_selector :xpath, "//table/tbody/tr[4]/td", text: "+91-9797979797"
        assert_selector :xpath, "//table/tbody/tr[5]/th/a", text: "Edit Profile"
      end

      within "#dashboard-tabs" do
        click_on "Properties"
      end

      assert_no_selector "#dashboard-account"
      assert_no_selector "#dashboard-profile"
      assert_selector "#dashboard-properties"
    end

    test "that errors will be displayed on profile edit form when accessed through dashboard" do
      access_profile_edit_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#edit_profile"

        within "form#edit_profile" do
          fill_in "profile_last_name", with: ""
          click_on "Update Profile"
        end

        assert_selector "#error_explanation li", text: "Last name can't be blank"
      end
    end

    test "that profile can be updated by profile edit form when accessed through dashboard" do
      access_profile_edit_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#edit_profile"

        within "form#edit_profile" do
          fill_in "profile_last_name", with: "User"
          click_on "Update Profile"
        end

        within "#dashboard-profile" do
          assert_selector :xpath, "//table/tbody/tr[3]/td", text: "User"
        end
      end

      assert_text "Welcome Second Dummy User"
      assert_selector "[role='toast']", text: "Your profile was successfully updated."
    end

    test "that cancel button for profile edit form is rendered only on dashboard" do
      visit edit_owners_profile_url

      assert_no_selector "a", text: "Cancel"

      access_profile_edit_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "a", text: "Cancel"
      end
    end

    test "that errors will be displayed on account edit form when accessed through dashboard" do
      access_account_edit_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#edit_owner"

        within "form#edit_owner" do
          click_on "Update"
        end

        assert_selector "#error_explanation li", text: "Current password can't be blank"
      end
    end

    test "that password can be updated by account edit form when accessed through dashboard" do
      access_account_edit_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#edit_owner"

        within "form#edit_owner" do
          fill_in "owner_password", with: "dassworp"
          fill_in "owner_password_confirmation", with: "dassworp"
          fill_in "owner_current_password", with: "password"
          click_on "Update"
        end

        within "#dashboard-account" do
          assert_selector :xpath, "//table/tbody/tr/td", text: "owner_two@example.com"
        end
      end

      assert_selector "[role='toast']", text: "Your account has been updated successfully."
    end

    test "that cancel button for account edit form is rendered only on dashboard" do
      visit edit_owner_registration_url

      assert_no_selector "a", text: "Cancel"

      access_account_edit_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "a", text: "Cancel"
      end
    end

    test "linking an owner account with an apartment through a property record" do
      access_property_creation_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#new_property"

        within "form#new_property" do
          select "17", from: "property_tower_number"
          fill_in "property_flat_number", with: "2301"
          fill_in "property_purchased_on", with: Time.zone.today - 6.years
          choose "property_registration_true"
          choose "property_primary_ownership_true"
          click_on "Create Property Record"
        end

        within "#dashboard-properties" do
          assert_selector :xpath, "//table/tbody/tr/td", text: "17"
          assert_selector :xpath, "//table/tbody/tr/td[2]", text: "2301"
          assert_selector :xpath, "//table/tbody/tr/td[3]", text: "Approved"
        end
      end

      assert_selector "[role='toast']", text: "Your Property record was successfully saved."
    end

    test "show errors if apartment info is filled but property info is not filled" do
      access_property_creation_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#new_property"

        within "form#new_property" do
          select "17", from: "property_tower_number"
          fill_in "property_flat_number", with: "2301"
          click_on "Create Property"

          assert_selector "#error_explanation li", text: "Purchased on can't be blank"
          assert_selector "#error_explanation li", text: "Registration status should be either \"Yes\" or \"No\""
          assert_selector "#error_explanation li", text: "Primary ownership status should be either \"Yes\" or \"No\""
        end
      end
    end

    test "show errors if apartment info is not filled but property info is filled" do
      access_property_creation_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#new_property"

        within "form#new_property" do
          fill_in "property_purchased_on", with: Time.zone.today - 6.years
          choose "property_registration_true"
          choose "property_primary_ownership_true"
          click_on "Create Property Record"

          assert_selector "#error_explanation li", text: "Tower number can't be blank"
          assert_selector "#error_explanation li", text: "Flat number can't be blank"
        end
      end
    end

    test "show errors if purchased on date is set in future" do
      access_property_creation_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#new_property"

        within "form#new_property" do
          select "17", from: "property_tower_number"
          fill_in "property_flat_number", with: "2301"
          fill_in "property_purchased_on", with: Time.zone.today + 6.months
          choose "property_registration_true"
          choose "property_primary_ownership_true"
          click_on "Create Property Record"

          assert_selector "#error_explanation li", text: "Purchased on date is invalid as it is set in future"
        end
      end
    end

    test "that cancel button is shoen for property creation form on dashboard" do
      access_property_creation_form_on_dashboard

      within "#dashboard-content" do
        assert_selector "form#new_property"
        assert_selector "a", text: "Cancel"

        click_on "Cancel"

        assert_selector "div#dashboard-properties"
        assert_no_selector "a", text: "Cancel"
      end
    end

    test "show property detials on dashboard" do
      property = @confirmed_linked_owner.properties.order("purchased_on ASC").first

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
        assert_selector :xpath, "//table/tbody/tr[1]/td", text: property.apartment.tower_number
        assert_selector :xpath, "//table/tbody/tr[2]/td", text: property.apartment.flat_number
        assert_selector :xpath, "//table/tbody/tr[3]/td", text: property.purchased_on.strftime("%d %B %Y")
        assert_selector :xpath, "//table/tbody/tr[4]/td", text: property.registered ? "Yes" : "No"
        assert_selector :xpath, "//table/tbody/tr[5]/td", text: property.primary_owner ? "Yes" : "No"
        assert_selector :xpath, "//table/tbody/tr[6]/th/a", text: "Go Back"

        click_on "Go Back"
      end

      assert_selector "#dashboard-properties"
    end

    test "update property record" do
      access_property_record_edit_form_on_dashboard
      property = @confirmed_linked_owner.properties.order("purchased_on ASC").first

      within "form#property_#{property.id}" do
        fill_in "property_purchased_on", with: property.purchased_on - 6.weeks
        click_on "Update Property"
      end

      assert_selector "[role='toast']", text: "Your Property record was successfully updated."

      within "#dashboard-properties" do
        within :xpath, "//table/tbody/tr[1]" do
          click_on "Details"
        end
      end

      within "#dashboard-property" do
        assert_selector(
          :xpath,
          "//table/tbody/tr[3]/td",
          text: (Time.zone.today - 3.years - 6.weeks).strftime("%d %B %Y")
        )
      end
    end

    test "show error if a field is kept blank in property record edit form" do
      access_property_record_edit_form_on_dashboard
      property = @confirmed_linked_owner.properties.order("purchased_on ASC").first

      within "form#property_#{property.id}" do
        fill_in "property_flat_number", with: ""
        click_on "Update Property"

        assert_selector "#error_explanation li", text: "Flat number can't be blank"
        assert_selector ".field_with_errors label[for='property_flat_number']"
      end
    end

    private

    def access_profile_edit_form_on_dashboard
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Profile"
      end

      within "#dashboard-profile" do
        click_on "Edit Profile"
      end
    end

    def access_account_edit_form_on_dashboard
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Account"
      end

      within "#dashboard-account" do
        click_on "Edit Account"
      end
    end

    def access_property_creation_form_on_dashboard
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Properties"
      end

      within "#dashboard-properties" do
        click_on "Add Property"
      end
    end

    def access_property_record_edit_form_on_dashboard
      visit owners_dashboard_url

      within "#dashboard-tabs" do
        click_on "Properties"
      end

      within "#dashboard-properties" do
        within :xpath, "//table/tbody/tr[1]" do
          click_on "Edit"
        end
      end
    end
  end
end
