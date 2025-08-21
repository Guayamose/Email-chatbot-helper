class UserMailer < ApplicationMailer
  def create_email(user, body, receiver)
    mail(to: receiver, from: user.email, subject: "Bem-vindo ao app!") do |format|
      format.html { render html: body.html_safe }
    end
  end
end
