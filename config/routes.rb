Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'pre_games#index'
  resources :boards
  resources :pre_games
  resources :games do
    member do
      post :turn
      get :production
      get :build_factory
      post :build_factory
      get :import
      post :import
    end
  end
  resources :pieces do
    member do
      put :move
    end
  end
end
