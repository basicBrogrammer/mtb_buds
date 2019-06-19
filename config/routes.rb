# frozen_string_literal: true

# require 'resque/server'
Rails.application.routes.draw do
  namespace :admin do
    resources :users
    root to: 'users#index'
    # authenticate :user do
    # mount Resque::Server, at: '/jobs'
    # end
  end

  unauthenticated do
    as :user do
      root to: 'home#index'
    end
  end
  root to: 'rides#index'

  scope :api do
    use_doorkeeper
  end

  namespace :api do
    devise_scope :user do
      get '/users/me' => 'users#me'
      resources :users, only: :create
    end
    resource :confirmations
    resources :rides
    resources :trails, only: :index
  end

  devise_for :users, controllers: { confirmations: 'confirmations' }

  resources :users, except: %i[new edit] do
    resources :settings, only: :update, controller: 'users/settings'
  end

  resources :my_rides, only: :index

  # order matters ??
  namespace :rides do
    resources :infinite_load, only: :index
  end
  resources :rides do
    scope module: 'rides' do
      resources :participations, only: %i[create update destroy]
      resources :participants, only: :index
      resources :comments, only: %i[index create]
    end
  end

  resources :notifications, only: :index
  namespace :notifications do
    resources :infinite_load, only: :index
  end

  resources :location_autocomplete, only: :index
  resources :trails, only: :index

  get '/pages/*id' => 'pages#show', as: :page, format: false
end
