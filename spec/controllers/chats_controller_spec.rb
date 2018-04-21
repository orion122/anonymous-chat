require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe "GET #welcome" do
    it "creates a one session" do
      get :welcome
      expect(Session.count).to eq(1)
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

    it "redirect to action show" do
      post :create
      expect(response).to redirect_to :action => :show,
                                      :token => assigns(:chat).token
    end

    it "redirect to action show with random chat's token" do
      post :create
      get :connect
      expect(response).to redirect_to :action => :show,
                                      :token => assigns(:chat).token
    end
  end
end
