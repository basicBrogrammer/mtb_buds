# frozen_string_literal: true

# Feature: Rides Index page
#   As a user
#   I want to see a list of rides
feature 'Rides index page', :devise, :js do
  let!(:rides) { create_list(:ride, 2) }

  context 'user' do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in_as(user)
      visit root_path

      # verify user signed in
      within 'nav' do
        expect(page).to have_link 'Brraapp!'
        expect(page).to have_selector '.navbar-avatar'
      end
    end

    scenario 'the root path displays a list of rides' do
      rides.each do |ride|
        expect(page).to have_content ride.trail['name']
      end
    end

    scenario "clicking 'interested' will take me to the ride's show page" do
      within '.card', match: :first do
        click_link 'Interested'
      end

      expect(page).to have_current_path ride_path(rides.first)
    end

    scenario 'the rides are infinitly scrollable'
  end

  context 'visitor' do
    before do
      visit rides_path

      # verify user is not signed in
      within 'nav' do
        expect(page).to have_link 'Sign in'
        expect(page).to have_link 'Sign up'
      end
    end

    scenario 'the root path displays a list of rides' do
      rides.each do |ride|
        expect(page).to have_content ride.trail['name']
      end
    end

    scenario "clicking 'interested' will take me the registration path" do
      within '.card', match: :first do
        click_link 'Interested'
      end
      expect(page).to have_content I18n.t('devise.failure.unauthenticated')

      within 'main' do
        expect(page).to have_content 'Sign in'
        expect(page).to have_selector '.new_user'
      end
    end
  end
end
