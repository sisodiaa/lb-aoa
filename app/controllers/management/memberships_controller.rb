module Management
  class MembershipsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_membership, except: :index
    before_action :set_status_from_membership, except: :index

    def index
      @status = params[:status]
      @pagy, @memberships = pagy(memberships_list, items: 10)
    end

    def edit; end

    def update
      perform_membership_state_transition if membership_params[:transition].present?
      set_admin_remark if membership_params[:transition] == "reject"

      if @membership.save(context: :membership_transition)
        @pagy, @memberships = pagy(memberships_list, items: 10)
        flash[:success] = "Membership state was successfully updated."

        OwnerMembershipMailer
          .with(membership: @membership)
          .membership_transition_notification
          .deliver_later

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to management_memberships_path }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def memberships_list
      Membership
        .includes(property: [:apartment, {owner: [:profile]}])
        .try!(@status.to_sym)
    rescue NoMethodError
      Membership
        .includes(property: [:apartment, {owner: [:profile]}])
        .order(created_at: :asc)
    end

    def set_membership
      @membership = Membership.find(params[:id])
    end

    def set_status_from_membership
      @status = @membership.membership_state
    end

    def perform_membership_state_transition
      @membership.try!(membership_params[:transition].to_sym)
    end

    def set_admin_remark
      @membership.remark = membership_params[:remark]
    end

    def membership_params
      params.require(:membership).permit(:transition, :remark)
    end
  end
end
