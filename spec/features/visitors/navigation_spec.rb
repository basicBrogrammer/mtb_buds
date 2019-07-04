# frozen_string_literal: true

# Feature: Navigation links
#   As a visitor
#   I want to see navigation links
#   So I can find home, sign in, or sign up
feature 'Navigation links', :devise do
  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "home," "sign in," and "sign up"
  scenario 'view navigation links' do
    visit root_path
    expect(page).to_not have_selector('nav')
    expect(page).to have_content 'Find new trails.'
    expect(page).to have_content 'Meet some cool people and shred some more gnar!'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
  end
end
