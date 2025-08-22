# app/mailers/chat_mailer.rb
class ChatMailer < ApplicationMailer
  default from: ENV.fetch("DEFAULT_FROM_EMAIL", "no-reply@example.com")

  def generic_email
    @body_html = params[:body_html].to_s
    mail(to: params[:to], subject: params[:subject]) do |format|
      format.html { render html: @body_html.html_safe }
      format.text { render plain: ActionView::Base.full_sanitizer.sanitize(@body_html) }
    end
  end
end
