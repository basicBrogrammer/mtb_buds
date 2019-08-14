# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :rides
    root to: 'users#index'
  end
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  unauthenticated do
    as :user do
      root to: 'home#index'
    end
  end
  root to: 'rides#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

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
  get '/service-worker.js' => 'service_worker#service_worker'
  get '/manifest.json' => 'service_worker#manifest'
end
