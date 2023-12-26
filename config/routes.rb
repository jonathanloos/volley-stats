Rails.application.routes.draw do
  resources :games do
    
    resources :volleyball_sets, shallow: true do
      resources :events, shallow: true

      get :log_events, on: :member
      resources :players, shallow: true
    end

    get :stats, on: :member
  end
  resources :users
  resources :teams

  # Defines the root path route ("/")
  root "teams#index"
end
