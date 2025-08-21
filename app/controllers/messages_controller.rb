class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)

    if @message.save
      files_text = ExtractText.from_attachments(@message.documents, max_chars: 15_000)
      politeness_label = @chat.politeness&.level || @chat.politeness&.name || @chat.politeness_id

      prompt = <<~PROMPT
        You are an assistant specialized in professional email communication.

        Rewrite the user's draft into a polished email.
        Tone politeness level: "#{politeness_label}".

        Output rules:
        - Return ONLY your final email wrapped in a single <div>.
        - Where you changed wording, make the changed phrases **bold** (Markdown).
        - No extra commentary.

        User draft:
        #{@message.content}

        #{files_text.present? ? "Additional context from attachments:\n#{files_text}" : ""}
      PROMPT

      @response = RubyLLM.chat.ask(prompt)

      ai_msg = @chat.messages.new(
        content: sanitize_email_div(@response.content),
        who_sent: "ai"
      )

      if ai_msg.save
        redirect_to chat_path(@chat)
      else
        @chats = current_user.chats
        @messages = @chat.messages.order(:created_at)
        render "chats/show", status: :unprocessable_entity
      end
    else
      @chats = current_user.chats
      @messages = @chat.messages.order(:created_at)
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def sanitize_email_div(html)
    helpers.sanitize(
      html.to_s,
      tags: %w[div p br strong b em ul ol li a],
      attributes: %w[href]
    )
  end

  def message_params
    params.require(:message).permit(:content, :who_sent, documents: [])  # <= allow files
  end
end
