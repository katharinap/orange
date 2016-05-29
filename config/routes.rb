Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resources :users, only: %i(show) do
    resources :weights, shallow: true
  end
  resources :exercises, only: %i(update create destroy edit new)
end
