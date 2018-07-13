Rails.application.routes.draw do
  root 'chats#welcome'

  resources :chats, only: [:create, :show], param: :token do
    collection do
      post :join_random
      post :enter_by_session_token
    end

    scope module: :chats do
      resources :messages, only: [:index, :create] do
        collection do
          post :set_state_read
        end
      end
    end
  end
end
