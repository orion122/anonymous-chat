require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe "GET #welcome" do
    it "creates a one session" do
      get :welcome
      expect(Session.count).to eq(1)
    end

    it "creates a chat with random session's token" do
      get :welcome
      expect(Session.find(1).token).to match(/[0-9a-zA-Z_-]{22}/)
    end

    it "render view welcome" do
      get :welcome
      expect(response).to render_template('welcome')
    end
  end


  describe "GET #create" do
    it "creates a one chat" do
      post :create
      expect(Chat.count).to eq(1)
    end

    it "creates a chat with default value false of 'filled'" do
      post :create
      expect(Chat.find(1).filled).to eq(false)
    end

    it "creates a chat with random chat's token" do
      post :create
      expect(Chat.find(1).token).to match(/[0-9a-zA-Z_-]{22}/)
    end

    it "redirect to action show" do
      post :create
      expect(response).to redirect_to :action => :show,
                                      :token => assigns(:chat).token
    end
  end


  describe "GET #show" do
    let(:chat)     { Chat.create(token: 12345) }

    it "assigns @chat" do
      get :show, params: { token: chat.token }
      expect(assigns(:chat)).to eq(chat)
    end

    it "render view show" do
      get :show, params: { token: chat.token }
      expect(response).to render_template('show')
    end
  end


  describe "GET #connect" do
    it "redirect to action show random chat" do
      post :create
      get :connect
      expect(response).to redirect_to :action => :show,
                                      :token => assigns(:chat).token
    end
  end
end
