require "test_helper"

module CMS
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
      @published_post = posts(:lotus)
    end

    teardown do
      @confirmed_board_admin = @draft_post = @published_post = nil
    end

    test "#authenticate_admin!" do
      get cms_posts_path
      assert_redirected_to new_admin_session_path
    end

    test "should get index" do
      authorised_admin do
        get cms_posts_url
        assert_response :success
      end
    end

    test "should get new" do
      skip
      authorised_admin do
        get new_cms_post_url
        assert_response :success
      end
    end

    test "should create post" do
      authorised_admin do
        assert_difference("Post.count") do
          post cms_posts_url, params: {
            post: {
              content: "<h1><em>Rich text</em> using HTML</h1>",
              title: "New title of a new post"
            }
          }
        end

        assert_redirected_to cms_post_url(Post.last)
      end
    end

    test "should show post" do
      authorised_admin do
        get cms_post_url(@draft_post)
        assert_response :success
      end
    end

    test "should get edit" do
      authorised_admin do
        get edit_cms_post_url(@draft_post)
        assert_response :success
      end
    end

    test "should update post" do
      authorised_admin do
        patch cms_post_url(@draft_post), params: {
          post: {
            title: "Updating the title of the post"
          }
        }

        assert_redirected_to cms_post_url(@draft_post)
      end
    end

    test "should destroy post" do
      authorised_admin do
        assert_difference("Post.count", -1) do
          delete cms_post_url(@draft_post)
        end

        assert_redirected_to cms_posts_url
      end
    end

    # authorisation cases

    test "can not edit a publishded post" do
      authorised_admin do
        get edit_cms_post_url(@published_post)
        assert_equal "You can not perform this action on a published post.",
          flash[:error]
      end
    end

    test "can not update a publishded post" do
      authorised_admin do
        patch cms_post_url(@published_post)
        assert_equal "You can not perform this action on a published post.",
          flash[:error]
      end
    end

    test "can not destroy a publishded post" do
      authorised_admin do
        delete cms_post_url(@published_post)
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
