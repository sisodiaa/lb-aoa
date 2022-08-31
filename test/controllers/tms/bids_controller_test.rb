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

    test "tms - show bids' list for under review and reviewed tenders only" do
      get tms_tender_bids_path(@upcoming_tender)
      assert_equal "You cannot perform this action.", flash[:error]

      get tms_tender_bids_path(@current_tender)
      assert_equal "You cannot perform this action.", flash[:error]

      get tms_tender_bids_path(@under_review_tender)
      assert_response :success

      get tms_tender_bids_path(@reviewed_tender)
      assert_response :success
    end

    test "tms - do not show bids' details for upcoming tenders" do
      get tms_tender_bid_path(@upcoming_tender, @upcoming_bid)
      assert_equal "You cannot perform this action.", flash[:error]
    end

    test "tms - do not show bids' details for current tenders" do
      get tms_tender_bid_path(@current_tender, @current_bid)
      assert_equal "You cannot perform this action.", flash[:error]
    end

    test "tms - show bids' details for under review tenders" do
      attach_file_to_record(
        @under_review_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      get tms_tender_bid_path(@under_review_tender, @under_review_bid)
      assert_response :success
    end

    test "tms - show bids' details for reviewed tenders" do
      attach_file_to_record(
        @reviewed_bid.document.file,
        "sheet.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
      get tms_tender_bid_path(@reviewed_tender, @reviewed_bid)
      assert_response :success
    end

    test "should get new" do
      get new_tender_bid_path(@current_tender)
      assert_response :success
    end

    test "create a new bid" do
      assert_difference "Bid.count" do
        assert_difference "Document.count" do
          post tender_bids_path(@current_tender), params: {
            bid: {
              name: "Wire Tech",
              email: "wiretech@example.com",
              document_attributes: {
                file: fixture_file_upload(
                  "sheet.xlsx",
                  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                )
              }
            }
          }
        end
      end

      assert_redirected_to tender_path(@current_tender)
      assert_equal "Bid was successfully submitted.", flash[:success]
    end

    test "show error message if bid can not be created" do
      assert_difference "Bid.count", 0 do
        assert_difference "Document.count", 0 do
          post tender_bids_path(@current_tender), params: {
            bid: {
              name: "",
              email: ""
            }
          }
        end
      end

      assert_equal "Bid was not created. Try again!", flash[:error]
      assert_response :unprocessable_entity
    end

    # authentication cases

    test "can not create a new bid for under review tender" do
      post tender_bids_path(@under_review_tender)
      assert_equal "You cannot perform this action.", flash[:error]
    end

    test "should not get new" do
      get new_tender_bid_path(@under_review_tender)
      assert_equal "You cannot perform this action.", flash[:error]
    end
  end
end
