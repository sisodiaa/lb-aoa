class AdminMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  def headers_for(action, opts)
    super.merge!({template_path: "accounts/admins/mailer"})
  end
end
