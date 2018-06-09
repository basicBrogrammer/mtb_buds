Rails.application.routes.draw do
  namespace :admin do
    resources :users
    root to: "users#index"
  end

  root to: 'rides#index'

  devise_for :users
  resources :users, except: [:new, :edit] do
    resources :settings, only: [:update]
  end

  resources :my_rides, only: :index
  # order matters ??
  namespace :rides do
    resources :infinite_load, only: :index
  end
  resources :rides do
    scope module: 'rides' do
      resources :participations, only: [:create, :update, :destroy]
      resources :participants, only: :index
      resources :comments, only: [:index, :create]
    end
  end

  resources :notifications, only: :index
  namespace :notifications do
    resources :infinite_load, only: :index
  end

  resources :location_autocomplete, only: :index
  resources :trails, only: :index

  get "/pages/*id" => 'pages#show', as: :page, format: false
end
