require "test_helper"

module Front
  class DiscussionPolicyTest < ActiveSupport::TestCase
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      @discussion = discussions(:rickshaw)
    end

    teardown do
      @discussion = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "#create" do
      assert Front::DiscussionPolicy.new(@owner_with_approved_membership, @discussion).create?
      assert_not Front::DiscussionPolicy.new(@owner_with_under_review_membership, @discussion).create?
    end

    test "#new" do
      assert Front::DiscussionPolicy.new(@owner_with_approved_membership, @discussion).new?
      assert_not Front::DiscussionPolicy.new(@owner_with_under_review_membership, @discussion).new?
    end

    test "#show" do
      assert Front::DiscussionPolicy.new(@owner_with_approved_membership, @discussion).show?
      assert_not Front::DiscussionPolicy.new(@owner_with_under_review_membership, @discussion).show?
    end

    test "#index" do
      assert Front::DiscussionPolicy.new(@owner_with_approved_membership, Discussion).index?
      assert_not Front::DiscussionPolicy.new(@owner_with_under_review_membership, Discussion).index?
    end
  end
end
