module Features
  module SessionHelpers
    include Warden::Test::Helpers

    def self.included(base)
      base.before(:each) { Warden.test_mode! }
      base.after(:each) { Warden.test_reset! }
    end

    def sign_up_with(email, password, confirmation)
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', :with => confirmation
      click_button 'Sign up'
    end

    def signin(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'user_password', with: password
      click_button 'Sign in'
    end
  end
end
