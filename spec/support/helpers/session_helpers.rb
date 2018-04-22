module Features
  module SessionHelpers
    include Warden::Test::Helpers

    def self.included(base)
      base.before(:each) { Warden.test_mode! }
      base.after(:each) { Warden.test_reset! }
    end

    def sign_up_with(email, password, confirmation, name: Faker::StarWars.unique.character )
      visit new_user_registration_path
      fill_in 'Name', with: name
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', :with => confirmation
      click_button 'Sign up'
    end

    def fill_out_sign_in_form(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'user_password', with: password
      click_button 'Sign in'
    end

    def sign_out
      logout(:user)
    end

    def sign_in_as(user)
      sign_out
      login_as(user, scope: :user)
    end
  end
end
