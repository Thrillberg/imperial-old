Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'pre_games#index'

  post '/games/:game_id/investors/:id/build_factory', to: 'investors#build_factory'
  post '/games/:game_id/investors/:id/import', to: 'investors#import'
  post '/games/:game_id/investors/:id/maneuver', to: 'investors#maneuver'
  post '/games/:game_id/investors/:id/maneuver_destination', to: 'investors#maneuver_destination'
  resources :pre_games
  resources :games do
    resources :investors do
      member do
        post :turn
        get :maneuver_destination
        get :maneuver
        get :investor_turn
      end
    end
  end
end
