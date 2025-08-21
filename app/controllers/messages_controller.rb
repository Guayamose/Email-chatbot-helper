class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])

    # Build the user message under this chat (includes any attached files)
    @message = @chat.messages.new(message_params)

    if @message.save
      # Extract text from attachments (cap length to protect tokens)
      files_text = ExtractText.from_attachments(@message.documents, max_chars: 15_000)

      # Make politeness readable (avoid interpolating the AR object itself)
      politeness_label = @chat.politeness&.level || @chat.politeness&.name || @chat.politeness_id

      # Compose a tight prompt
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

      # Call the LLM
      @response = RubyLLM.chat.ask(prompt)

      # Save AI reply
      ai_msg = @chat.messages.new(
        content: sanitize_email_div(@response.content),
        who_sent: "ai"
      )

      if ai_msg.save
        redirect_to chat_path(@chat)
      else
        @chats = current_user.chats
        @messages = @chat.messages.reload
        render "chats/show", status: :unprocessable_entity
      end
    else
      @chats = current_user.chats
      @messages = @chat.messages.reload
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  # Allow a safe subset of HTML so you can render the returned <div> without XSS
  def sanitize_email_div(html)
    helpers.sanitize(
      html.to_s,
      tags: %w[div p br strong b em ul ol li a],
      attributes: %w[href]
    )
  end

  def message_params
    params.require(:message).permit(:content, :who_sent, documents: [])
  end
end
