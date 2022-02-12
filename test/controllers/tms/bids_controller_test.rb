require "test_helper"

module TMS
  class BidsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @current_tender = tenders(:barb_wire)
      @under_review_tender = tenders(:water_purifier)
    end

    teardown do
      @current_tender = nil
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

    # authorisation cases

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
