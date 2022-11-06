require "test_helper"

module Management
  class DiscussionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
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
  end
end
