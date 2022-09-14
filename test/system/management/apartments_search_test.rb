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

    test "show results" do
      apartment = apartments(:apartment_six)

      visit management_search_apartments_url

      within "form#search_apartments_form" do
        fill_in "tower_number", with: "22"
        fill_in "flat_number", with: "404"
        click_on "Search"
      end

      within "#apartments ##{dom_id(apartment)}" do
        assert_selector "p", text: "2 record(s) linked"
      end
    end
  end
end
