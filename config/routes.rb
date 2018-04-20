Rails.application.routes.draw do
  root 'chats#welcome'

  get 'chats/:token' => 'chats#show'

  get 'chats/connect' => 'chats#connect'

  resources :chats

end
