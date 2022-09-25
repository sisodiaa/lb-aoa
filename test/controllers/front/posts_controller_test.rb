require "test_helper"

module Front
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      @private_post = posts(:lotus)
      @public_post = posts(:nursery)
    end

    teardown do
      @private_post = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "owner with an approved membership can access post for members" do
      sign_in @owner_with_approved_membership, scope: :owner

      get post_path(@private_post)
      assert_response :success

      sign_out :owner
    end

    test "owner without any approved membership can not access post for members" do
      sign_in @owner_with_under_review_membership, scope: :owner

      get post_path(@private_post)
      assert_redirected_to root_path
      assert_equal "You can not access this post unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end

    test "that visitor post can be accessed without signing in" do
      get post_path(@public_post)
      assert_response :success
    end

    test "that visitor post can be accessed by owner with under review membership" do
      sign_in @owner_with_under_review_membership, scope: :owner

      get post_path(@public_post)
      assert_response :success

      sign_out :owner
    end
  end
end
