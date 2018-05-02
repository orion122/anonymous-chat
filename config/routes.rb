Rails.application.routes.draw do
  root 'chats#welcome'

  post 'chats/join_random' => 'chats#join_random'

  post 'chats/save_message' => 'chats#save_message'

  get 'chats/messages' => 'chats#messages'

  get 'chats/:token' => 'chats#show'

  resources :chats

end
