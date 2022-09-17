require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  setup do
    @under_review_membership = memberships(:under_review_membership)
    @approved_membership = memberships(:approved_membership)
    @rejected_membership = memberships(:rejected_membership)
    @archived_membership = memberships(:archived_membership)
  end

  teardown do
    @under_review_membership = @approved_membership = @rejected_membership = @archived_membership = nil
  end

  test "that remkark is necessary when rejecting" do
    @rejected_membership.remark = ""
    assert_not @rejected_membership.valid?(:membership_transition), "Remark is not present"
  end

  test "that manual assignment of membership state will raise error" do
    assert_raises AASM::NoDirectAssignmentError do
      @under_review_membership.membership_state = :banned
    end
  end

  test "that `approve` event changes the membership state from under review to approved" do
    assert @under_review_membership.under_review?
    assert_not @under_review_membership.approved?

    @under_review_membership.approve

    assert_not @under_review_membership.under_review?
    assert @under_review_membership.approved?
  end

  test "that `reject` event changes the membership state from under review to rejected" do
    assert @under_review_membership.under_review?
    assert_not @under_review_membership.rejected?

    @under_review_membership.reject

    assert_not @under_review_membership.under_review?
    assert @under_review_membership.rejected?
  end

  test "that `scrutnize` event changes the membership state from approved to under review" do
    assert @approved_membership.approved?
    assert_not @approved_membership.under_review?

    @approved_membership.scrutinize

    assert_not @approved_membership.approved?
    assert @approved_membership.under_review?
  end

  test "that `scrutnize` event changes the membership state from rejected to under review" do
    assert @rejected_membership.rejected?
    assert_not @rejected_membership.under_review?

    @rejected_membership.scrutinize

    assert_not @rejected_membership.rejected?
    assert @rejected_membership.under_review?
  end

  test "that `archive` event changes the membership state from approved to archived" do
    assert @approved_membership.approved?
    assert_not @approved_membership.archived?

    @approved_membership.archive

    assert_not @approved_membership.approved?
    assert @approved_membership.archived?
  end
end
