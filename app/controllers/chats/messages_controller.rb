class Chats::MessagesController < Chats::ApplicationController
  def index
    if chat_has_session(chat, session_token)
      chat_messages = chat.messages

      chat_messages.find_each do |message|
        if message.accepted? && message.session.token != session_token
          message.deliver!
        end
      end

      render json: chat.messages
    else
      render body: nil, status: :forbidden
    end
  end

  def create
    if chat_has_session(chat, session_token)
      if params[:setStateRead]
        state_read(chat.messages)
      else
        session_id = chat.sessions.find_by(token: session_token).id
        session = Session.find(session_id)
        message = session.messages.new(message: params[:message])

        message.accept! if message.save
      end
    else
      render body: nil, status: :internal_server_error
    end
  end

  private

  def chat_has_session(chat, session_token)
    chat.sessions.where(token: session_token).exists?
  end

  def state_read(messages)
    messages.find_each do |message|
      if message.delivered? && message.session.token != session_token
        message.read!
      end
    end
  end
end
