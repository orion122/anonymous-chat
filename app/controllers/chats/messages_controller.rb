class Chats::MessagesController < Chats::ApplicationController
  before_action :chat_has_session, only: [:index, :create, :set_state_read]

  def index
    change_state(chat.messages, :may_deliver?, :deliver!)

    Rollbar.info('Get all messages')

    render json: chat.messages.includes(:session).order(:id).map {
        |message| message.as_json.merge({
                                            nickname: message.session.nickname.as_json,
                                            session_token: message.session.token.as_json
                                        })
    }
  end

  def create
    session_id = chat.sessions.find_by(token: session_token).id
    session = Session.find(session_id)
    message = session.messages.new(message: params[:message])

    message.accept! if message.save

    change_state(chat.messages, :may_deliver?, :deliver!)

    message_object = "{\"#{message.id}\": \"#{message.session.nickname}: #{message.message} (#{message.state})\"}"

    puts "=== #{message_object} ==="

    publication_create_message_event(message_object)

    Rollbar.info('Save message in DB')
  end

  def set_state_read
    change_state(chat.messages, :may_read?, :read!)

    last_message = chat.messages.last

    publication_state_read_event("{\"#{last_message.id}\": \"#{last_message.session.nickname}: #{last_message.message} (#{last_message.state})\"}")
  end

  private

  def chat_has_session
    if chat.sessions.where(token: session_token).empty?
      render body: nil, status: :forbidden
    end
  end

  def change_state(messages, from_state, to_state)
    messages.find_each do |message|
      if message.send(from_state) && message.session.token != session_token
        message.send(to_state)
      end
    end
  end

  def publication_create_message_event(message_object)
    require "nats/client"
    NATS.start do
      NATS.publish(params[:chat_token], message_object)
    end
  end

  def publication_state_read_event(message_object)
    require "nats/client"
    NATS.start do
      NATS.publish("#{params[:chat_token]}(read)", message_object)
    end
  end
end

