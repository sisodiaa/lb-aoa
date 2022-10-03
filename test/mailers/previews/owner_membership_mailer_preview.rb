# Preview all emails at http://localhost:3000/rails/mailers/owner_membership_mailer
class OwnerMembershipMailerPreview < ActionMailer::Preview
  def membership_transition_notification_for_rejection
    membership = Membership.rejected.first
    OwnerMembershipMailer.with(membership: membership).membership_transition_notification
  end

  def membership_transition_notification_for_approval
    membership = Membership.approved.first
    OwnerMembershipMailer.with(membership: membership).membership_transition_notification
  end
end
