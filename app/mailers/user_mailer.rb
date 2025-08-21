class UserMailer < ApplicationMailer
  def create_email(user, body, receiver, subject)
    mail(to: receiver, from: user, subject: subject) do |format|
      format.text { render plain: body }
    end
  end
end
