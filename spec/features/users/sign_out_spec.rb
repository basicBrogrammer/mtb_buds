# frozen_string_literal: true

# Feature: Sign out
#   As a user
#   I want to sign out
#   So I can protect my account from unauthorized access
feature 'Sign out', :devise, :js do
  # Scenario: User signs out successfully
  #   Given I am signed in
  #   When I sign out
  #   Then I see a signed out message
  scenario 'user signs out successfully' do
    user = FactoryBot.create(:user)
    fill_out_sign_in_form(user.email, user.password)

    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
    expect(page).to_not have_selector '#toast-container', wait: 10

    within 'nav' do
      find('.navbar-avatar').click

      within '#prof-drop' do
        click_link 'Sign Out'
      end
    end
    expect(page).to have_content I18n.t 'devise.sessions.signed_out'
  end
end
