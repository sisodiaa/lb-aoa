require "application_system_test_case"

module TMS
  class BidsTest < ApplicationSystemTestCase
    setup do
      @current_tender = tenders(:barb_wire)
      @reviewed_tender = tenders(:elevator_buttons)
    end

    teardown do
      @current_tender = nil
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
