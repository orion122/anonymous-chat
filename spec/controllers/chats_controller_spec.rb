require 'rails_helper'

RSpec.describe Chats::ChatsController, type: :controller do
  describe 'GET #welcome' do
    subject { get :welcome }

    it { is_expected.to be_success }

    it { is_expected.to render_template(:welcome) }
  end

  describe 'POST #create' do
    before { post :create, params: { session_token: SecureRandom.uuid } }

    it 'creates a one chat' do
      expect(Chat.count).to eq(1)
    end

    it "creates a chat with default value false of 'filled'" do
      expect(Chat.first.filled).to eq(false)
    end

    it 'creates a chat with random token' do
      post :create
      expect(Chat.first.token).not_to eq(Chat.second.token)
    end

    it 'creates a session with random token' do
      post :create, params: { session_token: SecureRandom.uuid }
      expect(Session.first.token).not_to eq(Session.second.token)
    end

    it 'render json where session_token_unique is true' do
      expect(response.body).to eq({ session_token_unique: true,
                                    chat_token: Chat.first.token }.to_json)
    end

    it { expect(Chat.first).to eq(Session.first.chat) }
  end

  describe 'POST #create with not unique session token' do
    let(:token) { '12345' }
    before do
      post :create, params: { session_token: :token }
      post :create, params: { session_token: :token }
    end

    it 'render json where session_token_unique is false' do
      expect(response.body).to eq({ session_token_unique: false }.to_json)
    end
  end

  describe 'GET #show' do
    let(:chat) { create(:chat) }

    subject { get :show, params: { token: chat.token } }

    it { is_expected.to render_template(:show) }
  end

  describe 'POST #join_random, when an empty chat exists' do
    before do
      post :create, params: { session_token: SecureRandom.uuid }
      post :join_random, params: { session_token: SecureRandom.uuid }
    end

    it 'render json where session_token_unique and free_chat_found is true' do
      expect(response.body).to eq({ session_token_unique: true,
                               free_chat_found: true,
                               chat_token: Chat.first.token }.to_json)
    end

    it 'sets @chat.filled to true' do
      expect(Chat.first.filled).to eq(true)
    end

    it { expect(Chat.first).to eq(Session.second.chat) }
  end

  describe 'POST #join_random with not unique session token' do
    let(:token) { '12345' }
    before do
      post :create, params: { session_token: :token }
      post :join_random, params: { session_token: :token }
    end

    it 'render json where session_token_unique is false' do
      expect(response.body).to eq({ session_token_unique: false }.to_json)
    end
  end

  describe "POST #join_random, when an empty chat doesn't exist" do
    before { post :join_random, params: { session_token: SecureRandom.uuid } }

    it 'render json where free_chat_found is false' do
      expect(response.body).to eq({ session_token_unique: true,
                                    free_chat_found: false }.to_json)
    end
  end
end
