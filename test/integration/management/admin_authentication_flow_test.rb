require "test_helper"

module Management
  class AdminAuthenticationFlowTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test "that email is dispatched when admin account is created through console" do
      assert_emails 1 do
        Admin.create!(
          email: "new_admin@example.com",
          first_name: "New",
          last_name: "Admin",
          password: "password",
          password_confirmation: "password"
        )
      end
    end

    test "that admin can not change its email" do
      sign_in @confirmed_board_admin, scope: :admin

      put admin_registration_path, params: {
        admin: {
          email: "admin_none@example.com",
          current_password: "password"
        }
      }

      assert_equal "admin_one@example.com", @confirmed_board_admin.reload.email
      sign_out :admin
    end
  end
end
