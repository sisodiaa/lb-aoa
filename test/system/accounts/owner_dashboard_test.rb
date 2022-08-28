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
        assert_selector :xpath, "//table/tbody/tr[2]/th/a", text: "Edit Account"
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
        assert_selector :xpath, "//table/tbody/tr[5]/th/a", text: "Edit Profile"
      end
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
  end
end
