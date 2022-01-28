require "test_helper"

module CMS
  class PublicationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
      @published_post = posts(:lotus)
    end

    teardown do
      @confirmed_board_admin = @draft_post = @published_post = nil
    end

    test "#authenticate_admin!" do
      patch publish_cms_post_path(@draft_post)
      assert_redirected_to new_admin_session_path
    end

    test "publish a post" do
      sign_in @confirmed_board_admin, scope: :admin

      authorised_admin do
        assert @draft_post.draft?
        assert_not @draft_post.published?
        assert_nil @draft_post.published_at

        patch publish_cms_post_path(@draft_post), params: {
          post: {
            publication_state: "published"
          }
        }

        assert_not @draft_post.reload.draft?
        assert @draft_post.published?
        assert_not_nil @draft_post.published_at
      end
    end

    test "publish action does not apply on published post" do
      authorised_admin do
        patch publish_cms_post_path(@published_post)
        assert_equal "You can not perform this action on a published post.",
          flash[:error]
      end
    end

    private

    def authorised_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
