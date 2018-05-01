class ChatsController < ApplicationController
  def welcome
    @session_token = SecureRandom.urlsafe_base64
    @chat = Chat.new
  end


  def create
    chat_token = SecureRandom.urlsafe_base64

    chat = Chat.create(token: chat_token)
    chat.sessions.find_or_create_by(token: params[:session_token])

    redirect_to action: "show", token: chat_token
  end


  def show
    @chat = Chat.find_by(token: params[:token])
    # gon.chat_token = @chat.token
  end


  def join_random
    random_chat = Chat.where(filled: false).order("RANDOM()").first

    if random_chat
      random_chat.sessions.create(token: params[:session_token])
      random_chat.update(filled: true)
      redirect_to action: "show", token: random_chat.token
    else
      flash[:alert] = "Пустых чатов нет. Создай свой."
      redirect_to action: "welcome"
    end
  end


  def messages
    chat = Chat.find_by(token: params[:chat_token])

    render json: chat.messages
  end
end
