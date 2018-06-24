class ChatsController < ApplicationController
  def welcome
    @session_token = SecureRandom.uuid
    gon.session_token = @session_token
    @chat = Chat.new
    gon.t_welcome = t('root.welcome')
    gon.csrf = form_authenticity_token
  end

  def create
    chat_token = SecureRandom.uuid

    chat = Chat.create(token: chat_token)
    chat.sessions.create(token: params[:session_token])

    redirect_to action: 'show', token: chat_token
  end

  def show
    gon.csrf = form_authenticity_token
  end

  def join_random
    random_chat = Chat.where(filled: false).order('RANDOM()').first

    if random_chat
      random_chat.sessions.create(token: params[:session_token])
      random_chat.update(filled: true)
      redirect_to action: 'show', token: random_chat.token
    else
      flash[:alert] = t('flash.alert')
      redirect_to action: 'welcome'
    end
  end
end
