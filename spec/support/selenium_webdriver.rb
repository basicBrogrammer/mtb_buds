require "selenium/webdriver"

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    # It's the `headless` arg that make Chrome headless
    # + you also need the `disable-gpu` arg due to a bug
    args: %w[headless disable-gpu window-size=1366,768],
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :selenium
