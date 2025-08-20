class ChatsController < ApplicationController
  def index
    @chats = Chat.all
    @chat = Chat.new
    @politeness = Politeness.all
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    if @chat.save
      redirect_to @chat
    else
      render :new
    end
  end

  def show
    @chats = Chat.all
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @politeness = Politeness.all
    @message = Message.new
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy

    redirect_back(fallback_location: chats_path, notice: "Chat excluído!")
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :receiver, :politeness_id)
  end
end
