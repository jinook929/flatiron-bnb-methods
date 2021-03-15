Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#home"

  resources :users

  resources :cities
  get 'cities/:id/openings', to: 'cities#openings'

  resources :neighborhoods

  resources :listings

  resources :reservations
  
  resources :reviews
end
