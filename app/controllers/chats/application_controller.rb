class Chats::ApplicationController < ApplicationController
  def session_token
    request.headers["X-Auth-Token"]
  end

  def chat
    Chat.find_by(token: params[:chat_token])
  end
end
