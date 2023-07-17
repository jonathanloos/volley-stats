Rails.application.routes.draw do
  resources :events
  resources :games do
    resources :volleyball_sets, shallow: true do
      get :log_events, on: :member
      resources :players, shallow: true
    end
  end
  resources :users
  resources :teams

  # Defines the root path route ("/")
  root "teams#index"
end
