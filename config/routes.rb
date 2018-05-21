Rails.application.routes.draw do
  root 'chats#welcome'

  resources :chats, only: [:create, :show], param: :token do
    collection do
      post :join_random
    end

    scope module: :chats do
      resources :messages, only: [:index, :create]
    end
  end
end
