# frozen_string_literal: true

require 'selenium/webdriver'

Capybara.register_driver :selenium do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[
        headless
        no-sandbox
        disable-popup-blocking
        --window-size=1280x1280
        --enable-features=NetworkService,NetworkServiceInProcess
      ]
    }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = :selenium
