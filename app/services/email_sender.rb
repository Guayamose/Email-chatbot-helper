class EmailSender
  def call(user, body, receiver, subject)
    UserMailer.create_email(user, body, receiver, subject).deliver_now
  end
end
