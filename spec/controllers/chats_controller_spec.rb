require 'rails_helper'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec.describe ChatsController, type: :controller do
  describe "GET #welcome" do
    before { get :welcome }

    it "response success" do
      expect(response).to be_success
    end

    it "render view welcome" do
      expect(response).to render_template(:welcome)
    end
  end


  describe "POST #create" do
    before { post :create, params: { session_token: SecureRandom.urlsafe_base64 } }

    it "creates a one chat" do
      expect(Chat.count).to eq(1)
    end

    it "creates a chat with default value false of 'filled'" do
      expect(Chat.first.filled).to eq(false)
    end

    it "creates a chat with random token" do
      post :create
      expect(Chat.first.token).not_to eq(Chat.second.token)
    end

    it "creates a session with random token" do
      post :create, params: { session_token: SecureRandom.urlsafe_base64 }
      expect(Session.first.token).not_to eq(Session.second.token)
    end

    it "redirect to action show" do
      expect(response).to redirect_to action: :show,
                                      token: Chat.first.token
    end

    it { expect(Chat.first).to eq(Session.first.chat) }
  end


  describe "GET #show" do
    let(:chat)     { create(:chat) }

    before { get :show, params: { token: chat.token } }

    it "render view show" do
      expect(response).to render_template('show')
    end
  end


  describe "POST #join_random, when an empty chat exists" do
    before {
      post :create, params: { session_token: SecureRandom.urlsafe_base64 }
      post :join_random, params: { session_token: SecureRandom.urlsafe_base64 }
    }

  it "redirect to action show random chat" do
      expect(response).to redirect_to action: :show,
                                      token: Chat.first.token
    end

    it "sets @chat.filled to true" do
      expect(Chat.first.filled).to eq(true)
    end

    it { expect(Chat.first).to eq(Session.second.chat) }
  end


  describe "POST #join_random, when an empty chat doesn't exist" do
    before { post :join_random, params: { session_token: SecureRandom.urlsafe_base64 } }

    it "redirect to action welcome" do
      expect(response).to redirect_to action: :welcome
    end

    it "show flash message" do
      expect(flash[:alert]).to eq(I18n.t('flash.alert'))
    end
  end


  describe "GET #messages" do
    # it "response JSON object" do
    #   post :create
    #   get :join_random
    #   Session.first.messages.create(message: 'abc')
    #   Session.second.messages.create(message: 'yxz')
    #   get :messages, params: { chat_token: assigns(:chat).token }
    #
    #   message1 = Session.first.messages
    #   message2 = Session.second.messages
    #
    #   sorted_messages_json = (message1 + message2).sort_by(&:created_at).to_json
    #   expect(response.body).to eq(sorted_messages_json)
    # end
  end
end
