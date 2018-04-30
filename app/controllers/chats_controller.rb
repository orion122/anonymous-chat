class ChatsController < ApplicationController
  def welcome
    @chat = Chat.new
  end


  def create
    @chat_token = SecureRandom.urlsafe_base64
    @session_token = SecureRandom.urlsafe_base64
    gon.session_token = @session_token

    @chat = Chat.create(token: @chat_token)
    @session = @chat.sessions.create(token: @session_token)

    redirect_to action: "show", token: @chat_token, session_token: @session_token
  end


  def show
    @chat = Chat.where(token: params[:token]).first
    @session_token = params[:session_token]

    gon.chat_token = @chat.token
    gon.session_token = @session_token
  end


  def connect
    @session_token = SecureRandom.urlsafe_base64
    gon.session_token = @session_token

    @random_chat = Chat.where(filled: false).order("RANDOM()").first

    if @random_chat
      @session = @random_chat.sessions.create(token: @session_token)
      @random_chat.update(filled: true)
      redirect_to action: "show", token: @random_chat.token, session_token: @session_token
    else
      flash[:alert] = "Пустых чатов нет. Создай свой."
      redirect_to action: "welcome"
    end
  end


  def messages
    chat = Chat.where(token: params[:chat_token]).first

    render json: chat.messages
  end
end
