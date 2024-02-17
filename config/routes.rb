Rails.application.routes.draw do
  resources :tournaments
  resources :games do
    
    resources :volleyball_sets, shallow: true do
      resources :events, shallow: true

      get :log_events, on: :member
      put :set_lineup, on: :member
      resources :players, shallow: true do
        put :substitution, on: :member
      end
    end

    get :stats, on: :member
  end
  resources :users
  resources :teams

  # load balancer health check
  get :up, to: "application#up"

  # Defines the root path route ("/")
  root "games#index"
end
