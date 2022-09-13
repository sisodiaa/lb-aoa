require "test_helper"

module Management
  module Search
    class OwnersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @confirmed_board_admin = admins(:confirmed_board_admin)
      end

      teardown do
        @confirmed_board_admin = nil
      end

      test "#authenticate_admin!" do
        get management_search_owners_path
        assert_redirected_to new_admin_session_path
      end

      test "only authenticated admin can access owners search" do
        sign_in @confirmed_board_admin, scope: :admin

        get management_search_owners_path
        assert_response :success

        sign_out :admin
      end
    end
  end
end
