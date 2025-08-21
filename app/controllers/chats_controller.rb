class ChatsController < ApplicationController
  def index
    @chats = current_user.chats
    @chat = Chat.new
    @politeness = Politeness.all
  end

  def create
  @chat = Chat.new(chat_params)
  @chat.user = current_user
  if @chat.save
    redirect_to @chat
  else
-   @chats = Chat.all
+   @chats = current_user.chats
    @politeness = Politeness.all
    render "index"
  end
end

  def show
    @chats = current_user.chats
    @chat = current_user.chats.find(params[:id])
    @messages = @chat.messages.order(:created_at)
    @politeness = Politeness.all
    @message = Message.new
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy

    redirect_back(fallback_location: chats_path, notice: "Chat deleted!")
  end

  def sendmail
    @chat = current_user.chats.find(params[:id])

    body_html = helpers.sanitize(
     params[:message_content].to_s,
     tags: %w[div p br strong b em ul ol li a],
     attributes: %w[href]
    )
    to        = params[:receiver].presence || @chat.receiver
    subject   = @chat.title.presence || "Message from MailAI"

    ChatMailer.with(to: to, subject: subject, body_html: body_html)
              .generic_email
              .deliver_later

    redirect_to @chat, notice: "Email sent to #{to}"
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :receiver, :politeness_id)
  end
end
