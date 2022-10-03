require "test_helper"

class OwnerMembershipMailerTest < ActionMailer::TestCase
  test "membership transition for rejected membership" do
    membership = memberships(:rejected_membership)

    email = OwnerMembershipMailer.with(membership: membership).membership_transition_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["no-reply@lbaoa.com"], email.from
    assert_equal ["owner_two@example.com"], email.to
    assert_equal "Your membership request for Flat 304 in Tower 8 has been rejected", email.subject
    assert_match membership.remark, email.html_part.body.encoded
    assert_match membership.remark, email.text_part.body.encoded
  end

  test "membership transition for approved membership" do
    membership = memberships(:approved_membership)

    email = OwnerMembershipMailer.with(membership: membership).membership_transition_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["no-reply@lbaoa.com"], email.from
    assert_equal ["owner_two@example.com"], email.to
    assert_equal "Your membership request for Flat 1102 in Tower 25 has been approved", email.subject
    assert_no_match "Remark by the Admin for rejecting your request is", email.html_part.body.encoded
    assert_no_match "Remark by the Admin for rejecting your request is", email.text_part.body.encoded
  end
end
