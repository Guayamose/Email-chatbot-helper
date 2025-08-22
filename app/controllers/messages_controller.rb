class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)

    if @message.save
      files_text = ExtractText.from_attachments(@message.documents, max_chars: 15_000)
      politeness_label = @chat.politeness&.level || @chat.politeness&.name || @chat.politeness_id
      receiver_label = @chat.receiver

      prompt = <<~PROMPT
        You are an assistant specialized in professional email communication.

        Task:
        - Read the email received from "#{receiver_label}".
        - Write a polished, ready-to-send reply to that email.
        - Match the language of the received email.
        - Tone politeness level: "#{politeness_label}".

        Output rules (STRICT):
        - Return ONLY one HTML element: a single <div> containing the reply.
        - Take into account the additional context from attachments (if any).
        - Inside the <div>, format the reply as a professional email using HTML:
          • Wrap each paragraph in <p style="margin:0 0 12px;"> ... </p>.
          • Start with an appropriate greeting in its own <p>.
          • Use short paragraphs (1–4 sentences each).
          • If helpful, include a concise bullet list with <ul><li>...</li></ul>.
          • End with a polite closing and signature placeholder in their own <p> and use <br> for line breaks in the signature.
        - No Markdown, no quotes of the original email, no explanations, no extra text outside the <div>.

        Email received:
        #{@message.content}

        #{files_text.present? ? "Additional context (from attachments):\n#{files_text}" : ""}
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
