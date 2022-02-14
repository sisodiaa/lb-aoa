require "test_helper"

module TMS
  class SelectionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)

      @selection = selections(:paani)

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
      @selection = nil
      @confirmed_board_admin = nil
    end

    test "#authenticate_admin!" do
      get new_tms_tender_bid_selection_path(@under_review_tender, @under_review_bid)
      assert_redirected_to new_admin_session_path
    end

    test "that only under review tender can select a bid" do
      authenticated_admin do
        post tms_tender_bid_selection_path(@upcoming_tender, @upcoming_bid)
        assert_equal "You cannot perform this action.", flash[:error]

        post tms_tender_bid_selection_path(@current_tender, @current_bid)
        assert_equal "You cannot perform this action.", flash[:error]

        post tms_tender_bid_selection_path(@reviewed_tender, @reviewed_bid)
        assert_equal "You cannot perform this action.", flash[:error]
      end
    end

    test "bid selection for a tender" do
      @selection.destroy

      assert @under_review_tender.under_review?

      authenticated_admin do
        assert_difference "Selection.count" do
          post tms_tender_bid_selection_path(@under_review_tender, @under_review_bid), params: {
            selection: {
              reason: "Value for money and time with good quality"
            }
          }
        end
      end

      assert_equal "Bid selection was successful.", flash[:success]
      assert_redirected_to tms_tender_url(@under_review_tender)
      assert @under_review_tender.reload.reviewed?
    end

    private

    def authenticated_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
