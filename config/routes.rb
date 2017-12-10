Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'pre_games#index'
  get '/map', to: 'maps#show'
  resources :pre_games
  resources :games
  resources :pieces do
    member do
      put :move
    end
  end
end
