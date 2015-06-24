Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'home#index'

  resources :home, only: [:index]
  resources :search, only: [:index]

  resources :hosts

end
