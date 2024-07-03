require "mail"
require "erb"

class UserMailer < ApplicationMailer
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  def account_activation(user)
    @user = user
    html_path = Rails.root.join("app", "views", "user_mailer", "account_activation.html.erb")
    text_path = Rails.root.join("app", "views", "user_mailer", "account_activation.text.erb")
    subject = "Activate Your Email"
    notify_user(@user, html_path, text_path, subject)
  end

  def notify_user(user, html, text, subject_text)
    template_path = html
    template = File.read(template_path)
    renderer = ERB.new(template)
    rendered_html = renderer.result(binding)

    text_template_path = text
    text_template = File.read(text_template_path)
    text_renderer = ERB.new(text_template)
    rendered_text = text_renderer.result(binding)

    mail = Mail.new do
      from    "danielalexiscruz2469@gmail.com"
      to      user.email
      subject subject_text

      text_part do
        body rendered_text
      end

      html_part do
        content_type "text/html; charset=UTF-8"
        body rendered_html
      end
    end

    mail.delivery_method :smtp, {
      address:              "smtp.gmail.com",
      port:                 587,
      user_name:            "danielalexiscruz2469@gmail.com",
      password:             "illyxjfjagbvksnk",
      authentication:       "plain",
      enable_starttls_auto: true
    }

    mail.deliver
  end

  def password_reset(user)
    @user = user
    html_path = Rails.root.join("app", "views", "user_mailer", "password_reset.html.erb")
    text_path = Rails.root.join("app", "views", "user_mailer", "password_reset.text.erb")
    subject = "Reset Your Password"
    notify_user(@user, html_path, text_path, subject)
  end
end
