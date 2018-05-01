Rails.application.routes.draw do
  root 'chats#welcome'

  post 'chats/join_random' => 'chats#join_random'

  get 'chats/messages' => 'chats#messages'

  get 'chats/:token' => 'chats#show'

  resources :chats

end
