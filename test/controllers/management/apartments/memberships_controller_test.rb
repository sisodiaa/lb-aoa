require "test_helper"

module Management
  module Apartments
    class MembershipsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @confirmed_board_admin = admins(:confirmed_board_admin)
        @apartment = apartments(:apartment_six)
      end

      teardown do
        @confirmed_board_admin = @apartment = nil
      end

      test "#authenticate_admin!" do
        get management_apartments_memberships_path(@apartment)
        assert_redirected_to new_admin_session_path
      end

      test "only authenticated admin can view owners properties" do
        sign_in @confirmed_board_admin, scope: :admin

        get management_apartments_memberships_path(@apartment)
        assert_response :success

        sign_out :admin
      end
    end
  end
end
