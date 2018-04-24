class ChatsController < ApplicationController
  def welcome
    #@session_token = SecureRandom.urlsafe_base64
    #Session.create(token: @session_token)

    @chat = Chat.new
  end


  def create
    @chat_token = SecureRandom.urlsafe_base64
    @session_token = SecureRandom.urlsafe_base64

    @chat = Chat.create(token: @chat_token)
    @session = @chat.sessions.create(token: @session_token)

    redirect_to action: "show", token: @chat_token, session_token: @session_token
  end


  def show
    @chat = Chat.where(token: params[:token]).first

    @session_token = params[:session_token]
  end


  def connect
    @session_token = SecureRandom.urlsafe_base64

    @random_chat = Chat.where(filled: false).order("RANDOM()").first
    @session = @random_chat.sessions.create(token: @session_token)
    @random_chat.update_attribute(:filled, true)

    redirect_to action: "show", token: @random_chat.token, session_token: @session_token
  end
end
