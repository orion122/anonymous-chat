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
    gon.session_token = @session_token

    # @messages_first_session = @chat.sessions.first.messages
    # @messages_second_session = @chat.sessions.second.messages

    # gon.messages_first_session = @messages_first_session
    # gon.messages_second_session = @messages_second_session

    # gon.sorted_messages = (@messages_first_session + @messages_second_session).sort_by(&:created_at)
  end


  def connect
    @session_token = SecureRandom.urlsafe_base64
    gon.session_token = @session_token

    @random_chat = Chat.where(filled: false).order("RANDOM()").first
    @session = @random_chat.sessions.create(token: @session_token)
    @random_chat.update(filled: true)

    redirect_to action: "show", token: @random_chat.token, session_token: @session_token
  end
end
