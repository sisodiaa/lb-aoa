require "test_helper"

module Front
  class PostPolicyTest < ActiveSupport::TestCase
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      @post = posts(:lotus)
    end

    teardown do
      @post = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "#show" do
      assert Front::PostPolicy.new(@owner_with_approved_membership, @post).show?
      assert_not Front::PostPolicy.new(@owner_with_under_review_membership, @post).show?
    end

    test "#resolve" do
      posts = Front::PostPolicy::Scope.new(@owner_with_approved_membership, Post).resolve
      assert_equal ["members", "visitors"], posts.pluck(:visibility_state).uniq
      assert_equal 9, posts.count

      posts = Front::PostPolicy::Scope.new(@owner_with_under_review_membership, Post).resolve
      assert_equal ["visitors"], posts.pluck(:visibility_state).uniq
      assert_equal 1, posts.count
    end
  end
end
