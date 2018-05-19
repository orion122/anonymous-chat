class ChatsController < ApplicationController
  def welcome
    @session_token = SecureRandom.uuid
    @chat = Chat.new
  end


  def create
    chat_token = SecureRandom.uuid

    chat = Chat.create(token: chat_token)
    chat.sessions.create(token: params[:session_token])

    redirect_to action: "show", token: chat_token
  end


  def show
  end


  def join_random
    random_chat = Chat.where(filled: false).order("RANDOM()").first

    if random_chat
      random_chat.sessions.create(token: params[:session_token])
      random_chat.update(filled: true)
      redirect_to action: "show", token: random_chat.token
    else
      flash[:alert] = t('flash.alert')
      redirect_to action: "welcome"
    end
  end
end
