# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'
gem 'rails', '~> 5.2.0'

gem 'administrate'
gem 'airbrake', '~> 5.0'
gem 'aws-sdk-s3', require: false
gem 'browser'
gem 'devise'
gem 'devise_invitable'
gem 'doorkeeper'
gem 'faraday'
gem 'fast_jsonapi'
gem 'figaro'
gem 'geocoder'
gem 'google_places'
gem 'hashie'
gem 'high_voltage'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'materialize-form'
gem 'materialize-sass', '~> 1.0.0.beta'
gem 'pg', '~> 1.00'
gem 'puma', '~> 3.7'
gem 'rack-cors'
gem 'redis-rails'
gem 'resque'
gem 'resque-scheduler'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'slack-notifier'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'cli-ui'
  gem 'dokku-cli'
  # gem 'letter_opener'
  # gem 'bullet'
  # gem 'capistrano', '~> 3.0.1'
  # gem 'capistrano-bundler'
  # gem 'capistrano-rails', '~> 1.1.0'
  # gem 'capistrano-rails-console'
  # gem 'capistrano-rvm', '~> 0.1.1'
  gem 'foreman'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'hub', require: nil
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails_layout'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 3.00'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'rubocop', '0.64'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
end

group :test do
  gem 'database_cleaner'
  gem 'launchy'
end
