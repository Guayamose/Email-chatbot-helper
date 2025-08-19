class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message.chat = @chat
    @message = Message.new(message_params)
    if @message.save
      redirect_to chat_path(@chat)
      prompt = <<-PROMPT
                  You are an assistant specialized in professional email communication.

                  I'm new at work and I want to learn how to write this #{@message.content} properly
                  depending on this level of politeness #{@chat.politeness}.

                  Guide me into how to write the perfect email depending on who i'm talking to

                  show me your version of the email marking the difference between both.
                PROMPT

      @response = RubyLLM.chat.ask(prompt)

    else
      render 'chats/show', status: :unprocessable_content
    end
  end

  def message_params
    params.require(:message).permit(:content, :who_sent)
  end
end
