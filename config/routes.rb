Rails.application.routes.draw do

  resources :hosts, only: [:index]

end
