class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :unauthorised_request

  unless Rails.env.production?
    around_action :n_plus_one_detection

    def n_plus_one_detection
      Prosopite.scan
      yield
    ensure
      Prosopite.finish
    end
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      management_root_path
    end
  end

  def unauthorised_request(exception)
    policy_name = exception.policy.class.to_s.underscore

    respond_to do |format|
      format.turbo_stream do
        flash.now[:error] = t "#{policy_name}.#{exception.query}",
          scope: "pundit", default: :default
      end

      format.html do
        flash[:error] = t "#{policy_name}.#{exception.query}",
          scope: "pundit", default: :default
      end
    end

    redirect_to(request.referer || root_path)
  end
end
