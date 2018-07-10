class ChatsController < ApplicationController
  def welcome
    @session_token = SecureRandom.uuid
    gon.session_token = @session_token
    @chat = Chat.new
    gon.csrf_token = form_authenticity_token
  end

  def create
    if Session.find_by(token: params[:session_token])
      render json: { session_token_unique: false }
      return
    end

    chat_token = SecureRandom.uuid
    chat = Chat.create(token: chat_token)
    chat.sessions.create(token: params[:session_token])

    render json: {
        session_token_unique: true,
        chat_token: chat_token
    }
  end

  def show; end

  def join_random
    if Session.find_by(token: params[:session_token])
      render json: { session_token_unique: false }
      return
    end

    random_chat = Chat.where(filled: false).order('RANDOM()').first
    if random_chat
      random_chat.sessions.create(token: params[:session_token])
      random_chat.update(filled: true)

      render json: {
          session_token_unique: true,
          free_chat_found: true,
          chat_token: random_chat.token
      }
    else
      render json: {
          session_token_unique: true,
          free_chat_found: false
      }
    end
  end
end
