Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'pre_games#index'
  post '/games/:game_id/investors/:id/build_factory', to: 'investors#build_factory'
  post '/games/:game_id/investors/:id/import', to: 'investors#import'
  resources :boards
  resources :pre_games
  resources :games do
    resources :investors do
      member do
        post :turn
      end
    end

    member do
      post :next_turn
      get :production
      get :build_factory
      post :build_factory
      get :import
      post :import
      get :maneuver
      post :maneuver
      get :maneuver_destination
      post :maneuver_destination
      get :taxation
      get :investor_turn
      post :investor_turn
    end
  end
  resources :pieces do
    member do
      put :move
    end
  end
end
