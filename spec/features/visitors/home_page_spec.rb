# frozen_string_literal: true

# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do
  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Welcome"
  scenario 'visit the home page' do
    visit root_path
    expect(page).to have_content 'MTB Group Rides'
    expect(page).to have_content 'Find new trails.'
    expect(page).to have_content 'See what trails others are riding near you.'
    expect(page).to have_content 'Join the community.'
    expect(page).to have_selector '.home-screen__action'
    expect(page).to have_selector '.home-screen'
    expect(page).to have_selector '.home-screen__details'
  end
end
