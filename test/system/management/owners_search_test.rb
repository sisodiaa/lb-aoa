require "application_system_test_case"

module Management
  class OwnersSearchTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = nil
      Warden.test_reset!
    end

    test "that only search form is displayed on inital request with any search params" do
      visit management_search_owners_url

      within "form#search_owners_form" do
        assert_no_selector "#error_explanation"
      end

      within "#main" do
        assert_no_text "No record found for"
      end
    end

    test "show error message if no email is provided" do
      visit management_search_owners_url

      within "form#search_owners_form" do
        click_on "Search"
        assert_selector "#error_explanation li", text: "Email can not be blank"
      end
    end

    test "show message if no result is found" do
      visit management_search_owners_url

      within "form#search_owners_form" do
        fill_in "email", with: "not_found@example.com"
        click_on "Search"
      end

      within "#owners" do
        assert_text "No record found for not_found@example.com"
      end
    end

    test "show results" do
      owner = owners(:confirmed_linked_owner)

      visit management_search_owners_url

      within "form#search_owners_form" do
        fill_in "email", with: owner.email
        click_on "Search"
      end

      assert_selector "#owners ##{dom_id(owner)}"
    end
  end
end
