# frozen_string_literal: true

feature 'Participation rejecting', :devise, :js do
  let!(:user) { create(:user) }
  let!(:owner) { create(:user) }

  let!(:ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:other_ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:participation) { create(:participation, :pending, ride: ride, user: user) }

  context 'owner' do
    scenario 'can accept a participant and the participant will not see their self on the participant list' do
      sign_in_as(user)
      visit ride_path(ride)
      expect(page).to_not have_content user.name
      expect(page).to have_content 'Riders: 1'

      sign_in_as owner
      visit ride_path(ride)
      open_riders_collapse

      within '.collection-item', text: user.name do
        expect(page).to have_content 'pending'
        click_button 'Reject'
      end

      expect(page).to have_current_path ride_path(ride)
      expect(page).to have_content I18n.t('participant.rejected')

      open_riders_collapse
      within '.collection-item', text: user.name do
        expect(page).to_not have_content 'pending'
        expect(page).to have_content 'rejected'
        expect(page).to_not have_button 'Reject'
        expect(page).to_not have_button 'Accept'
      end

      sign_in_as user
      visit ride_path(ride)

      expect(page).to_not have_content user.name
    end
  end

  context 'user' do
    before do
      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
    end

    scenario 'will not see a link to reject' do
      open_riders_collapse
      within '.collection.participants' do
        expect(all('.collection-item').count).to eq 1
        expect(page).to have_content owner.name
        expect(page).to_not have_content user.name
      end
    end
  end
end
