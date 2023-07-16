Rails.application.routes.draw do
  resources :players
  resources :events
  resources :volleyball_sets
  resources :games
  resources :users
  resources :teams
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
