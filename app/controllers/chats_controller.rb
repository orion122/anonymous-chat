class ChatsController < ApplicationController
  def welcome
    @session_token = SecureRandom.urlsafe_base64
    Session.create(token: @session_token)

    @chat = Chat.new
  end


  def create
    @chat_token = SecureRandom.urlsafe_base64
    @chat = Chat.create(token: @chat_token)

    redirect_to action: "show", token: @chat_token
  end


  def show
    @chat = Chat.where(token: params[:token]).first
  end


  def connect

  end
end
