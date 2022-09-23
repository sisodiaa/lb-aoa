require "test_helper"

module CMS
  class ClassificationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @private_post = posts(:lotus)
      @public_post = posts(:nursery)
    end

    teardown do
      @confirmed_board_admin = @private_post = @public_post = nil
    end

    test "#authenticate_admin!" do
      patch classify_cms_post_path(@public_post)
      assert_redirected_to new_admin_session_path
    end

    test "classify a post" do
      authenticated_admin do
        assert @public_post.visitors?
        assert_not @public_post.members?

        patch classify_cms_post_path(@public_post)

        assert_not @public_post.reload.visitors?
        assert @public_post.members?
      end
    end

    test "declassify a post" do
      authenticated_admin do
        assert @private_post.members?
        assert_not @private_post.visitors?

        patch classify_cms_post_path(@private_post)

        assert_not @private_post.reload.members?
        assert @private_post.visitors?
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
