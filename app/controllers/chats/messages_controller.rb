class Chats::MessagesController < Chats::ApplicationController
  before_action :chat_has_session, only: [:index, :create, :set_state_read]

  def index
    change_state(chat.messages, :accepted?, :deliver!)
    render json: chat.messages
  end

  def create
    session_id = chat.sessions.find_by(token: session_token).id
    session = Session.find(session_id)
    message = session.messages.new(message: params[:message])

    if message.save
      message.accept!
    else
      render body: nil, status: :internal_server_error
    end
  end

  def set_state_read
    change_state(chat.messages, :delivered?, :read!)
  end

  private

  def chat_has_session
    if chat.sessions.where(token: session_token).empty?
      render body: nil, status: :forbidden
    end
  end

  def change_state(messages, from_state, to_state)
    messages.find_each do |message|
      if message.send(from_state) && message.session.token != session_token
        message.send(to_state)
      end
    end
  end
end
