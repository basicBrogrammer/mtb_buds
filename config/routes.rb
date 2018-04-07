Rails.application.routes.draw do
  resources :rides
  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'rides#index'
  devise_for :users
  resources :users, except: [:new, :edit]
  resources :location_autocomplete, only: :index
end
