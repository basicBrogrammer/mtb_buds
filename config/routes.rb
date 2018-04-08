Rails.application.routes.draw do
  namespace :admin do
    resources :users
    root to: "users#index"
  end

  root to: 'rides#index'

  devise_for :users
  resources :users, except: [:new, :edit]

  resources :rides
  resources :location_autocomplete, only: :index
  resources :trails, only: :index
end
