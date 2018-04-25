Rails.application.routes.draw do
  root 'chats#welcome'

  get 'chats/connect' => 'chats#connect'

  get 'chats/messages' => 'chats#messages'

  get 'chats/:token' => 'chats#show'

  resources :chats

end
