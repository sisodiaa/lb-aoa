require "test_helper"

module Front
  class CommentPolicyTest < ActiveSupport::TestCase
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      @comment = comments(:rickshaw_comment_one)
    end

    teardown do
      @comment = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "#create" do
      assert Front::CommentPolicy.new(@owner_with_approved_membership, @comment).create?
      assert_not Front::CommentPolicy.new(@owner_with_under_review_membership, @comment).create?
    end

    test "#new" do
      assert Front::CommentPolicy.new(@owner_with_approved_membership, @comment).new?
      assert_not Front::CommentPolicy.new(@owner_with_under_review_membership, @comment).new?
    end

    test "#show" do
      assert Front::CommentPolicy.new(@owner_with_approved_membership, @comment).show?
      assert_not Front::CommentPolicy.new(@owner_with_under_review_membership, @comment).show?
    end

    test "#index" do
      assert Front::CommentPolicy.new(@owner_with_approved_membership, Comment).index?
      assert_not Front::CommentPolicy.new(@owner_with_under_review_membership, Comment).index?
    end
  end
end
