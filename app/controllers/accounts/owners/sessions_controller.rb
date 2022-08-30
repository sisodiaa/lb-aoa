# frozen_string_literal: true

class Accounts::Owners::SessionsController < Devise::SessionsController
  layout -> { turbo_frame_request? ? false : "front" }

  before_action :turbo_frame_request_variant

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
