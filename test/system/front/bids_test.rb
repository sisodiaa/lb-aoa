require "application_system_test_case"

module Front
  class BidsTest < ApplicationSystemTestCase
    setup do
      @reviewed_tender = tenders(:elevator_buttons)
      @reviewed_bid = bids(:elevatorwala)

      @under_review_tender = tenders(:water_purifier)
      @under_review_bid = bids(:waterwala)

      @current_tender = tenders(:barb_wire)
      @current_bid = bids(:wirewala)

      @upcoming_tender = tenders(:air_quality_monitors)
      @upcoming_bid = bids(:airwala)

      @bid = bids(:waterwala)
    end

    teardown do
      @upcoming_tender = @current_tender = @under_review_tender = @reviewed_tender = nil
      @upcoming_bid = @current_bid = @under_review_bid = @reviewed_bid = nil
      @bid = nil
    end

    test "list and show bids" do
      attach_file_to_record(
        @bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )

      visit tender_url(@under_review_tender)

      assert_selector "#bidDropdownButton"
      assert_selector "#bidDropdown", visible: :hidden
      click_button "Submitted Bids"
      assert_selector "#bidDropdown", visible: true

      assert_no_selector "#bid_#{@bid.quotation_token}"
      within "#bidDropdown" do
        assert_selector "li.tender-bid", count: 4
        click_link "#{@bid.name} - #{@bid.quotation_token}"
      end

      assert_selector "#bid_#{@bid.quotation_token}"
    end

    test "only reviewed and under review tenders show bids' list" do
      attach_file_to_record(
        @reviewed_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      visit tender_url(@reviewed_tender)
      assert_selector "#bidDropdownButton"

      attach_file_to_record(
        @under_review_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      visit tender_url(@under_review_tender)
      assert_selector "#bidDropdownButton"

      attach_file_to_record(
        @current_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      visit tender_url(@current_tender)
      assert_no_selector "#bidDropdownButton"
    end
  end
end
