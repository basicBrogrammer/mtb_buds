# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MtbBuds
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.cache_store = :redis_store, ENV.fetch('REDIS_URL', 'redis://localhost:6379/0/cache'), { expires_in: 14.days }
    config.active_job.queue_adapter = :resque

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
