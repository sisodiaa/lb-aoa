require "test_helper"

module Management
  class MembershipsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test "#authenticate_admin!" do
      get management_memberships_path
      assert_redirected_to new_admin_session_path
    end
  end
end
