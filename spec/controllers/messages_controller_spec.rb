require 'rails_helper'

RSpec.describe Chats::MessagesController, type: :controller do
  describe 'POST #messages with valid session token in header' do
    let(:chat) { create(:chat) }
    let(:session) { create(:session, chat: chat) }
    let(:text) { 'some text' }

    before do
      request.headers['X-Auth-Token'] = session.token
      post :create, params: { chat_token: chat.token, message: text }
    end

    it 'creates a one message' do
      expect(Message.count).to eq(1)
    end

    it 'saved message is equal to sent message' do
      expect(Message.first.message).to eq(text)
    end

    it 'message belongs to session' do
      expect(Message.first.session).to eq(session)
    end

    it "message state is 'accepted'" do
      expect(Message.first.state).to eq('accepted')
    end
  end

  describe 'POST #messages with invalid session token in header' do
    let(:chat) { create(:chat) }
    let(:text) { 'some text' }

    subject do
      request.headers['X-Auth-Token'] = '123'
      post :create, params: { chat_token: chat.token, message: text }
    end

    it { expect { subject }.not_to change { Message.count }.from(0) }

    it { is_expected.to have_http_status(403) }
  end

  describe "GET #messages with owner's session token in header" do
    let(:chat) { create(:chat) }
    let(:session1) { create(:session, chat: chat) }
    let(:session2) { create(:session, chat: chat) }
    let(:text) { 'some text' }

    before do
      request.headers['X-Auth-Token'] = session1.token
      post :create, params: { chat_token: chat.token, message: text }
      get :index, params:   { chat_token: chat.token }
    end

    it 'return message' do
      expect(response.body).to eq(chat.messages.includes(:session).order(:id).map { |message|
        message.as_json.merge(
          nickname: 'nickname',
          session_token: session1.token
        )
      }.to_json)
    end

    it 'message state is accepted' do
      expect(Message.first.state).to eq('accepted')
    end
  end

  describe "GET #messages with not owner's session token in header" do
    let(:chat) { create(:chat) }
    let(:session1) { create(:session, chat: chat) }
    let(:session2) { create(:session, chat: chat) }
    let(:text) { 'some text' }

    before do
      request.headers['X-Auth-Token'] = session1.token
      post :create, params: { chat_token: chat.token, message: text }

      request.headers['X-Auth-Token'] = session2.token
      get :index, params: { chat_token: chat.token }
    end

    it 'return message' do
      expect(response.body).to eq(chat.messages.includes(:session).order(:id).map { |message|
        message.as_json.merge(
          nickname: 'nickname',
          session_token: session1.token
        )
      }.to_json)
    end

    it 'message state is delivered' do
      expect(Message.first.state).to eq('delivered')
    end
  end

  describe 'GET #messages with invalid session token in header' do
    let(:chat) { create(:chat) }
    let(:session1) { create(:session, chat: chat) }
    let(:text) { 'some text' }

    before do
      request.headers['X-Auth-Token'] = session1.token
      post :create, params: { chat_token: chat.token, message: text }

      request.headers['X-Auth-Token'] = '123'
      get :index, params: { chat_token: chat.token }
    end

    it 'return status 403' do
      expect(response).to have_http_status(403)
    end

    it 'message state is accepted' do
      expect(Message.first.state).to eq('accepted')
    end
  end

  describe "set state 'read'" do
    let(:chat) { create(:chat) }
    let(:session1) { create(:session, chat: chat) }
    let(:session2) { create(:session, chat: chat) }
    let(:message) { create(:message, state: 'delivered', session: session1) }

    before do
      request.headers['X-Auth-Token'] = session1.token
      post :create, params: { chat_token: chat.token, message: message }

      request.headers['X-Auth-Token'] = session2.token
      post :set_state_read, params: { chat_token: chat.token }
    end

    it "message state is 'read'" do
      expect(Message.first.state).to eq('read')
    end
  end
end
