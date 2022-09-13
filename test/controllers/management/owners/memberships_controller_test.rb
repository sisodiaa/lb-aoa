require "test_helper"

module Management
  module Owners
    class MembershipsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @confirmed_board_admin = admins(:confirmed_board_admin)
        @confirmed_linked_owner = owners(:confirmed_linked_owner)
      end

      teardown do
        @confirmed_board_admin = @confirmed_linked_owner = nil
      end

      test "#authenticate_admin!" do
        get management_owners_memberships_path(@confirmed_linked_owner)
        assert_redirected_to new_admin_session_path
      end

      test "only authenticated admin can view owners properties" do
        sign_in @confirmed_board_admin, scope: :admin

        get management_owners_memberships_path(@confirmed_linked_owner)
        assert_response :success

        sign_out :admin
      end
    end
  end
end
