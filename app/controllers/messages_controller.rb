class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.chats = Chat.find(params[:chat_id])
    if @message.save
      redirect_to @message
    else
      render :new
    end
  end

  def message_params
    params.require(:message).permit(:content, :who_sent)
  end

  def new
    @message = Message.new
  end

  def show
    @message = Message.find(params[:id])
  end

  def index
    @messages = Message.all
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to messages_path
  end

  
end
