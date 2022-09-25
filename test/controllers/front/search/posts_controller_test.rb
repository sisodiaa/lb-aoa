require "test_helper"

module Front
  module Search
    class PostsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
        sign_in @owner_with_under_review_membership, scope: :owner
      end

      teardown do
        sign_out :owner
        @owner_with_under_review_membership = nil
      end

      test "#index" do
        get search_posts_path
        assert_redirected_to root_path
        assert_equal "You can not search unless you have an Approved membership.", flash[:error]
      end

      test "#results" do
        get results_search_posts_path
        assert_redirected_to root_path
        assert_equal "You can not search unless you have an Approved membership.", flash[:error]
      end

      test "#new" do
        get new_search_post_path
        assert_redirected_to root_path
        assert_equal "You can not search unless you have an Approved membership.", flash[:error]
      end
    end
  end
end
