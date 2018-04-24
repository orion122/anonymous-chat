require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe "GET #welcome" do
    it "creates a one session" do
      get :welcome
      expect(response).to be_success
    end

    it "render view welcome" do
      get :welcome
      expect(response).to render_template('welcome')
    end
  end


  describe "POST #create" do
    it "creates a one chat" do
      post :create
      expect(Chat.count).to eq(1)
    end

    it "creates a chat with default value false of 'filled'" do
      post :create
      expect(Chat.find(1).filled).to eq(false)
    end

    it "creates a chat with random token" do
      post :create
      expect(Chat.find(1).token).to match(/[0-9a-zA-Z_-]{22}/)
    end

    it "creates a session with random token" do
      post :create
      expect(Session.find(1).token).to match(/[0-9a-zA-Z_-]{22}/)
    end

    it "redirect to action show" do
      post :create
      expect(response).to redirect_to :action => :show,
                                      :token => assigns(:chat).token,
                                      :session_token => assigns(:session).token
    end
  end


  describe "GET #show" do
    let(:chat)     { Chat.create(token: 12345) }
    let(:session)  { chat.sessions.create(token: 12345) }
    let(:messages) { session.messages }

    it "assigns @chat" do
      get :show, params: { token: chat.token, session_token: session.token }
      expect(assigns(:chat)).to eq(chat)
    end

    it "render view show" do
      get :show, params: { token: chat.token, session_token: session.token }
      expect(response).to render_template('show')
    end
  end


  describe "POST #connect" do
    it "redirect to action show random chat" do
      post :create
      get :connect
      expect(response).to redirect_to :action => :show,
                                      :token => assigns(:chat).token,
                                      :session_token => assigns(:session).token
    end

    it "creates a session with random token" do
      post :create
      expect(Session.find(1).token).to match(/[0-9a-zA-Z_-]{22}/)
    end
  end
end
