Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resources :exercises, only: %i(index)
  resources :weights, only: %i(index)
  resources :users, only: [] do
    resources :exercises, shallow: true, except: %i(show)
    resources :weights, shallow: true, except: %i(show)
    resources :courses, shallow: true, except: %i(show)
  end
end
