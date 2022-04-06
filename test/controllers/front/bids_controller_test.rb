require "test_helper"

module TMS
  class BidsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @upcoming_tender = tenders(:air_quality_monitors)
      @upcoming_bid = bids(:airwala)

      @current_tender = tenders(:barb_wire)
      @current_bid = bids(:wirewala)

      @under_review_tender = tenders(:water_purifier)
      @under_review_bid = bids(:waterwala)

      @reviewed_tender = tenders(:elevator_buttons)
      @reviewed_bid = bids(:elevatorwala)
    end

    teardown do
      @upcoming_tender = @current_tender = @under_review_tender = @reviewed_tender = nil
      @upcoming_bid = @current_bid = @under_review_bid = @reviewed_bid = nil
    end

    test "to_param" do
      assert_equal(
        "/tenders/notice/#{@upcoming_tender.id}-tech-club_house-0920/bids/#{@upcoming_bid.quotation_token}",
        tender_bid_path(@upcoming_tender, @upcoming_bid)
      )
    end

    test "show bids' list for under review and reviewed tenders only" do
      get tender_bids_path(@upcoming_tender)
      assert_equal "You cannot perform this action.", flash[:error]

      get tender_bids_path(@current_tender)
      assert_equal "You cannot perform this action.", flash[:error]

      get tender_bids_path(@under_review_tender)
      assert_response :success

      get tender_bids_path(@reviewed_tender)
      assert_response :success
    end

    test "show bids' details for under review and reviewed tenders only" do
      get tender_bid_path(@upcoming_tender, @upcoming_bid)
      assert_equal "You cannot perform this action.", flash[:error]

      get tender_bid_path(@current_tender, @current_bid)
      assert_equal "You cannot perform this action.", flash[:error]

      attach_file_to_record(
        @under_review_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      get tender_bid_path(@under_review_tender, @under_review_bid)
      assert_response :success

      attach_file_to_record(
        @reviewed_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      get tender_bid_path(@reviewed_tender, @reviewed_bid)
      assert_response :success
    end
  end
end
