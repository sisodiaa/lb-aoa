require "test_helper"

module CMS
  class TagsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test "#authenticate_admin!" do
      get cms_tags_path
      assert_redirected_to new_admin_session_path
    end

    test "should get index" do
      sign_in @confirmed_board_admin, scope: :admin
      get cms_tags_path
      assert_response :success
      sign_out :admin
    end
  end
end
