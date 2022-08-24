class OwnerMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  def headers_for(action, opts)
    super.merge!({template_path: "accounts/owners/mailer"})
  end
end
