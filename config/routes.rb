Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'games#index'
  resources :games
  resources :pieces do
    member do
      put :move
    end
  end
end
