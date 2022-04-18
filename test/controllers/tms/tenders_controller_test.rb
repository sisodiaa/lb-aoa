require "test_helper"

module TMS
  class TendersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
      @published_tender = tenders(:air_quality_monitors)
    end

    teardown do
      @confirmed_board_admin = @draft_tender = @published_tender = nil
    end

    test "#authenticate_admin!" do
      get new_tms_tender_path
      assert_redirected_to new_admin_session_path
    end

    test "should get new" do
      authenticated_admin do
        get new_tms_tender_path
        assert_response :success
      end
    end

    test "to_param" do
      assert_equal "/tms/tenders/#{@draft_tender.id}-SEP_21-tech-79", tms_tender_path(@draft_tender)
    end

    test "update a tender" do
      authenticated_admin do
        patch tms_tender_url(@draft_tender), params: {
          tender: {
            title: "new title"
          }
        }

        assert_equal "Tender was successfully updated.", flash[:success]
      end
    end

    test "return unprocessable_entity if update was not successful" do
      authenticated_admin do
        patch tms_tender_url(@draft_tender), params: {
          tender: {
            title: ""
          }
        }

        assert_response :unprocessable_entity
      end
    end

    test "should destroy tender" do
      authenticated_admin do
        assert_difference("Tender.count", -1) do
          delete tms_tender_url(@draft_tender)
        end

        assert_redirected_to tms_tenders_url
      end
    end

    # authentication cases

    test "can not edit a published tender" do
      authenticated_admin do
        get edit_tms_tender_url(@published_tender)
        assert_equal "You can not perform this action on a published tender.",
          flash[:error]
      end
    end

    test "can not update a published tender" do
      authenticated_admin do
        patch tms_tender_url(@published_tender)
        assert_equal "You can not perform this action on a published tender.",
          flash[:error]
      end
    end

    test "can not destroy a published tender" do
      authenticated_admin do
        delete tms_tender_url(@published_tender)
        assert_equal "You can not perform this action on a published tender.",
          flash[:error]
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
