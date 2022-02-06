require "test_helper"

module TMS
  class TendersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
    end

    teardown do
      @confirmed_board_admin = @draft_tender = nil
    end

    test "#authenticate_admin!" do
      get new_tms_tender_path
      assert_redirected_to new_admin_session_path
    end

    test "should get new" do
      authenticated_admin do
        get new_cms_post_url
        assert_response :success
      end
    end

    test "to_param" do
      assert_equal "/tms/tenders/#{@draft_tender.id}-SEP_21-tech-79", tms_tender_path(@draft_tender)
    end

    test "should destroy tender" do
      authenticated_admin do
        assert_difference("Tender.count", -1) do
          delete tms_tender_url(@draft_tender)
        end

        assert_redirected_to tms_tenders_url
      end
    end

    private

    def authenticated_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
