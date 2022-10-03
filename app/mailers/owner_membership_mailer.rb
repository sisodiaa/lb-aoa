class OwnerMembershipMailer < ApplicationMailer
  def membership_transition_notification
    @membership = params[:membership]
    @apartment = @membership.property.apartment
    @owner = @membership.property.owner
    @profile = @owner.profile

    subject = "Your membership request for Flat #{@apartment.flat_number} in Tower " \
              "#{@apartment.tower_number} has been #{@membership.membership_state}"

    mail(to: @owner.email, subject: subject)
  end
end
