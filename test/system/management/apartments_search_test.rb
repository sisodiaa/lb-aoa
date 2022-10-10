require "application_system_test_case"

module Management
  class ApartmentsSearchTest < ApplicationSystemTestCase
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

    test "that only search form is displayed on inital request without any search params" do
      visit management_search_apartments_url

      within "form#search_apartments_form" do
        assert_no_selector "#error_explanation"
      end

      within "#main" do
        assert_no_text "No record found for"
      end
    end

    test "show error message if tower number is not present" do
      visit management_search_apartments_url

      within "form#search_apartments_form" do
        fill_in "flat_number", with: "501"
        click_on "Search"
        assert_selector "#error_explanation li", text: "Tower number can not be blank"
      end
    end

    test "show error message if flat number is not present" do
      visit management_search_apartments_url

      within "form#search_apartments_form" do
        fill_in "tower_number", with: "6"
        click_on "Search"
        assert_selector "#error_explanation li", text: "Flat number can not be blank"
      end
    end

    test "show message if no result is found" do
      visit management_search_apartments_url

      within "form#search_apartments_form" do
        fill_in "tower_number", with: "6"
        fill_in "flat_number", with: "501"
        click_on "Search"
      end

      within "#apartments" do
        assert_text "No record found for Flat 501 of Tower 6"
      end
    end

    test "show results and navigate to linked memberships" do
      apartment = apartments(:apartment_two)

      visit management_search_apartments_url

      within "form#search_apartments_form" do
        fill_in "tower_number", with: "9"
        fill_in "flat_number", with: "2105"
        click_on "Search"
      end

      within "#apartments ##{dom_id(apartment)}" do
        assert_selector "p", text: "2 record(s) linked"
        click_on "View linked memberships"
      end

      assert_selector "#_memberships"
    end
  end
end
