require "test_helper"

module Accounts
  module Owners
    class DashboardsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @confirmed_linked_owner = owners(:confirmed_linked_owner)
      end

      teardown do
        @confirmed_linked_owner = nil
      end

      test "#authenticate_owner!" do
        get owners_dashboard_path
        assert_redirected_to new_owner_session_path
      end

      test "#authenticate_owner! - account" do
        get account_owners_dashboard_path
        assert_redirected_to new_owner_session_path
      end

      test "#authenticate_owner! - profile" do
        get profile_owners_dashboard_path
        assert_redirected_to new_owner_session_path
      end

      test "show profile to authenticated owner" do
        authenticated_owner do
          get owners_dashboard_path
          assert_response :success
        end
      end

      private

      def authenticated_owner
        sign_in @confirmed_linked_owner, scope: :owner
        yield if block_given?
        sign_out :owner
      end
    end
  end
end
