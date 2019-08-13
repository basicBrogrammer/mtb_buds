# frozen_string_literal: true

# Feature: User edit
#   As a user
#   I want to edit my user profile
#   So I can change my email address
feature 'User edit', :devise do
  # Scenario: User changes email address
  #   Given I am signed in
  #   When I change my email address
  #   Then I see an account updated message
  scenario 'user changes email address', :js do
    user = create(:user)
    sign_in_as(user)
    visit edit_user_registration_path(user)
    find('.collapsible-header', text: 'User Settings').click
    fill_in 'user_email', with: 'newemail@example.com'
    fill_in 'Current password', with: user.password
    click_button 'Update'
    txts = [I18n.t('devise.registrations.updated'), I18n.t('devise.registrations.update_needs_confirmation')]
    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  scenario 'user changes location', :js do
    user = create(:user)
    original_location = user.location
    original_latitude = user.latitude
    original_longitude = user.longitude
    location = 'Santa Cruz, CA'

    sign_in_as(user)
    visit edit_user_registration_path(user)
    find('.collapsible-header', text: 'User Settings').click

    select2_search location.slice(0, 5), choice: location, from: '.user_location'
    fill_in 'Current password', with: user.password
    click_button 'Update'

    txts = [I18n.t('devise.registrations.updated'), I18n.t('devise.registrations.update_needs_confirmation')]
    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
    user.reload
    expect(user.location).to_not eq original_location
    expect(user.location).to include 'Santa Cruz, CA'
    expect(user.latitude).to_not eq original_latitude
    expect(user.latitude.round(2)).to eq 36.97
    expect(user.longitude).to_not eq original_longitude
    expect(user.longitude.round(2)).to eq -122.03
  end

  # Scenario: User cannot edit another user's profile
  #   Given I am signed in
  #   When I try to edit another user's profile
  #   Then I see my own 'edit profile' page
  scenario "user cannot cannot edit another user's profile", :me do
    me = create(:user)
    other = create(:user, email: 'other@example.com')
    sign_in_as(me)
    visit edit_user_registration_path(other)
    expect(page).to have_field('user_email', with: me.email)
  end
end
