require "application_system_test_case"

module TMS
  class BidsTest < ApplicationSystemTestCase
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
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
      @confirmed_board_admin = @bid = nil
    end

    test "tms - list and show bids" do
      attach_file_to_record(
        @bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )

      login_as @confirmed_board_admin, scope: :admin
      visit tms_tender_url(@under_review_tender)

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
      logout :admin
    end

    test "tms - only reviewed and under review tenders show bids' list" do
      attach_file_to_record(
        @reviewed_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      login_as @confirmed_board_admin, scope: :admin
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
      logout :admin
    end

    test "show validation errors and flash message if nothing is submitted" do
      visit tender_url(@current_tender)

      within("#tender-bid") do
        assert_no_selector "form"
        click_on "Submit a bid"
        assert_selector "form"
        assert_no_selector "#error_explanation"
        click_on "Submit Bid"
        assert_selector "#error_explanation"
      end

      assert_selector "[role='toast']", text: "Bid was not created. Try again!"
    end

    test "submit a bid" do
      visit tender_url(@current_tender)

      within("#tender-bid") do
        click_on "Submit a bid"

        fill_in "bid_name", with: "wirewirewire"
        fill_in "bid_email", with: "wirewirewire@example.com"
        fill_in "bid_note", with: "it is a note"
        attach_file "bid_document_attributes_file",
          Rails.root.join("test", "fixtures", "files", "sheet.xlsx"),
          visible: false
        click_on "Submit Bid"
      end
      assert_selector "[role='toast']", text: "Bid was successfully submitted."
      assert_text "Reference token for this bid is #{Bid.last.reload.quotation_token}"
    end

    test "only current tenders can have bid submission" do
      visit tender_url(@reviewed_tender)
      assert_no_selector "#tender-bid"
    end
  end
end
