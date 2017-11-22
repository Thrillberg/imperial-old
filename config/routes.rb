Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'games#index'
  resources :games
  resources :pieces do
    member do
      put :move
    end
  end
end
