Rails.application.routes.draw do
  root 'chats#welcome'

  get 'chats/:token' => 'chats#show'

  resources :chats

end
