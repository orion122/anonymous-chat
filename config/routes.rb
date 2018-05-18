Rails.application.routes.draw do
  root 'chats#welcome'

  resources :chats, only: [:create, :show], param: :token do
    collection do
      post :join_random
    end

    resources :messages, only: [:index, :create]
  end
end
