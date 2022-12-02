require "test_helper"

module Management
  class DiscussionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @discussion = discussions(:rickshaw)
    end

    teardown do
      @discussion = @confirmed_board_admin = nil
    end

    test "#authenticate_admin!" do
      get management_discussions_path
      assert_redirected_to new_admin_session_path
    end

    test "only authenticated admin can access discussion topics" do
      sign_in @confirmed_board_admin, scope: :admin

      get management_discussions_path
      assert_response :success

      sign_out :admin
    end

    test "successful update" do
      sign_in @confirmed_board_admin, scope: :admin

      patch management_discussion_path(@discussion), params: {
        discussion: {
          accessibility_state: :locked
        }
      }

      assert_equal "Accessibility state was successfully modified.", flash[:success]
      assert_redirected_to management_discussions_path

      sign_out :admin
    end

    test "failed update" do
      sign_in @confirmed_board_admin, scope: :admin

      patch management_discussion_path(@discussion), params: {
        discussion: {
          accessibility_state: :locking
        }
      }

      assert_response :unprocessable_entity

      sign_out :admin
    end
  end
end
