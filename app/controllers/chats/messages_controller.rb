class Chats::MessagesController < Chats::ApplicationController
  def index
    if chat_has_session(chat, session_token)
      change_state(chat.messages, :accepted?, :deliver!)
      render json: chat.messages
    else
      render body: nil, status: :forbidden
    end
  end

  def create
    if chat_has_session(chat, session_token)
    session_id = chat.sessions.find_by(token: session_token).id
    session = Session.find(session_id)
    message = session.messages.new(message: params[:message])
    message.accept! if message.save
    else
      render body: nil, status: :internal_server_error
    end
  end

  def set_state_read
    if chat_has_session(chat, session_token)
      change_state(chat.messages, :delivered?, :read!)
    else
      render body: nil, status: :forbidden
    end
  end

  private

  def chat_has_session(chat, session_token)
    chat.sessions.where(token: session_token).exists?
  end

  def change_state(messages, from_state, to_state)
    messages.find_each do |message|
      if message.send(from_state) && message.session.token != session_token
        message.send(to_state)
      end
    end
  end
end
