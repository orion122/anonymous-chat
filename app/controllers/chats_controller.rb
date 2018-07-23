class ChatsController < ApplicationController
  def welcome
    @session_token = SecureRandom.uuid
    gon.session_token = @session_token
    @chat = Chat.new
    Rollbar.info('Visiting the main page')
  end

  def create
    if session_found_by_token
      render json: { session_token_unique: false }
      return
    end

    chat_token = SecureRandom.uuid
    nickname = Haikunator.haikunate(0, ' ').titleize
    chat = Chat.create(token: chat_token)
    chat.sessions.create(token: params[:session_token], nickname: nickname)

    Rollbar.info('Create a chat')

    render json: {
        session_token_unique: true,
        chat_token: chat_token
    }
  end

  def show; end

  def join_random
    if session_found_by_token
      render json: { session_token_unique: false }
      return
    end

    random_chat = Chat.where(filled: false).order('RANDOM()').first
    if random_chat
      nickname = Haikunator.haikunate(0, ' ').titleize
      random_chat.sessions.create(token: params[:session_token], nickname: nickname)
      random_chat.update(filled: true)

      Rollbar.info('Join a random chat')

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

  def enter_by_session_token
    if session_found_by_token

      Rollbar.info('Enter a chat by session token')

      render json: {
          session_token_found: true,
          chat_token: session_found_by_token.chat.token
      }
    else
      render json: {
          session_token_found: false
      }
    end

  end
end
