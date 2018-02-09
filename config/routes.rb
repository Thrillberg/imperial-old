Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'pre_games#index'

  resources :pre_games
  resources :games do
    resources :log_entries, only: [:index]
    resources :investors do
      member do
        post :turn
        get :maneuver_destination
        post :maneuver_destination
        get :maneuver
        post :maneuver
        get :investor_turn
        post :import
        post :build_factory
      end
    end
  end
end
