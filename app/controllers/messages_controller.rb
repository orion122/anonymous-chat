class MessagesController < ApplicationController
  def index
    chat = Chat.find_by(token: params[:chat_token])

    chat_messages = chat.messages
    chat_messages.map{ |message| message.deliver! if message.accepted? }

    render json: chat.messages
  end


  def create
    session = Session.find_by(token: params[:session_token])
    message = session.messages.new(message: params[:message])

    message.forward! if message.unsent?
    message.accept! if message.save
  end
end
