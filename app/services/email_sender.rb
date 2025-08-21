class EmailSender
  def call(user, body, receiver)
    UserMailer.create_email(user, body, receiver).deliver_now
  end
end
