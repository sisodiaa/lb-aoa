require "test_helper"

module CMS
  class PostTagsTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
      @category = categories(:horticulture)
    end

    teardown do
      @category = @draft_post = @confirmed_board_admin = nil
    end

    test "that tags get created along with the post" do
      authenticated_admin do
        assert_difference "Post.count" do
          assert_difference "Tag.count", 2 do
            assert_difference "Tagging.count", 2 do
              post cms_posts_path, params: {
                post: {
                  category_id: @category.id,
                  title: "New title of a new post",
                  content: "<h1><em>Rich text</em> using HTML</h1>",
                  tags_list: "new , draft post "
                }
              }
            end
          end
        end
      end

      assert_redirected_to cms_post_path(Post.last)
    end

    test "that Taggings get deleted along with Post but Tags do not" do
      authenticated_admin do
        assert_difference "Post.count", -1 do
          assert_difference "Tag.count", 0 do
            assert_difference "Tagging.count", -2 do
              delete cms_post_url(@draft_post)
            end
          end
        end
      end

      assert_redirected_to cms_posts_url
    end

    private

    def authenticated_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
