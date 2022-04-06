require "application_system_test_case"

module TMS
  class SelectionTest < ApplicationSystemTestCase
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

      @bid = bids(:paaniwala)
      @selection = selections(:paani)
    end

    teardown do
      @upcoming_tender = @current_tender = @under_review_tender = @reviewed_tender = nil
      @upcoming_bid = @current_bid = @under_review_bid = @reviewed_bid = nil
      @confirmed_board_admin = @bid = nil
    end

    test "show validation error if reason is not given" do
      @selection.destroy

      attach_file_to_record(
        @bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )

      login_as @confirmed_board_admin, scope: :admin
      visit tms_tender_url(@under_review_tender)
      click_button "Submitted Bids"
      within "#bidDropdown" do
        click_link "#{@bid.name} - #{@bid.quotation_token}"
      end
      within("#bid_#{@bid.quotation_token}") do
        click_link "Select Bid"
        within("form") do
          click_on "Select this bid"

          assert_selector "form li", text: "Reason can't be blank"
        end
      end

      logout :admin
    end

    test "bid selection" do
      @selection.destroy

      attach_file_to_record(
        @bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )

      login_as @confirmed_board_admin, scope: :admin
      visit tms_tender_url(@under_review_tender)
      click_button "Submitted Bids"
      within "#bidDropdown" do
        click_link "#{@bid.name} - #{@bid.quotation_token}"
      end
      within("#bid_#{@bid.quotation_token}") do
        click_link "Select Bid"
        within("form") do
          fill_in "selection_reason", with: "Value for money and time with good quality"
          click_on "Select this bid"
        end
      end

      within(".tender-selection") do
        assert_text "Awarded to #{@bid.quotation_token} by #{@bid.name}"
        assert_text @under_review_tender.selection.reason
      end
      assert_selector "[role='toast']", text: "Bid selection was successful."

      logout :admin
    end
  end
end
