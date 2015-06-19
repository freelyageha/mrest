Rails.application.routes.draw do

  root to: 'home#index'

  resources :home, only: [:index]
  resources :search, only: [:index]

  resources :hosts

end
