class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def session
    Session.find_by(token: params[:session_token])
  end
end
