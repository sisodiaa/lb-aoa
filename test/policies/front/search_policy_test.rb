require "test_helper"

module Front
  class SearchPolicyTest < ActiveSupport::TestCase
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      @post = posts(:lotus)
    end

    teardown do
      @post = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "#index?" do
      assert Front::SearchPolicy.new(@owner_with_approved_membership, Front::Search::PostForm.new).index?
      assert_not Front::SearchPolicy.new(@owner_with_under_review_membership, Front::Search::PostForm.new).index?
    end

    test "#results?" do
      assert Front::SearchPolicy.new(@owner_with_approved_membership, Front::Search::PostForm.new).results?
      assert_not Front::SearchPolicy.new(@owner_with_under_review_membership, Front::Search::PostForm.new).results?
    end

    test "#new?" do
      assert Front::SearchPolicy.new(@owner_with_approved_membership, Front::Search::PostForm.new).new?
      assert_not Front::SearchPolicy.new(@owner_with_under_review_membership, Front::Search::PostForm.new).new?
    end
  end
end
