class MessagesController < ApplicationController
  def index
    chat = Chat.find_by(token: params[:chat_token])
    session_token = request.headers["X-Auth-Token"]

    if chat_has_session(chat, session_token)
      chat_messages = chat.messages
      chat_messages.map{ |message| message.deliver! if message.accepted? and message.session.token != session_token }
      render json: chat.messages
    else
      render json: { 'permission': 'false' }
    end
  end


  def create
    chat = Chat.find_by(token: params[:chat_token])
    session_token = request.headers["X-Auth-Token"]

    if chat_has_session(chat, session_token)
      session_id = chat.sessions.find_by(token: session_token).id
      session = Session.find(session_id)
      message = session.messages.new(message: params[:message])

      message.forward! if message.unsent?
      message.accept! if message.save

      #render json: { 'state': message.state }
    else
      render json: { 'permission': 'false' }
    end
  end


  private
  def chat_has_session (chat, session_token)
    chat.sessions.where(token: session_token).exists?
  end
end
