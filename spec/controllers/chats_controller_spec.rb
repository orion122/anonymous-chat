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

    it 'redirect to action show' do
      expect(response).to redirect_to action: :show,
                                      token: Chat.first.token
    end

    it { expect(Chat.first).to eq(Session.first.chat) }
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

    it 'redirect to action show random chat' do
      expect(response).to redirect_to action: :show,
                                      token: Chat.first.token
    end

    it 'sets @chat.filled to true' do
      expect(Chat.first.filled).to eq(true)
    end

    it { expect(Chat.first).to eq(Session.second.chat) }
  end

  describe "POST #join_random, when an empty chat doesn't exist" do
    before { post :join_random, params: { session_token: SecureRandom.uuid } }

    it 'redirect to action welcome' do
      expect(response).to redirect_to action: :welcome
    end

    it 'show flash message' do
      expect(flash[:alert]).to eq(I18n.t('flash.alert'))
    end
  end
end
