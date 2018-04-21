feature 'Participation accepting', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }
  let!(:owner) { FactoryBot.create(:user) }

  let!(:ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:other_ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:participation) { create(:participation, :pending, ride: ride, user: user) }

  context 'owner' do
    before do
      sign_in_as(owner)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
    end

    scenario 'can accept a participant and the participant will see their self on the participant list' do
      sign_in_as(user)
      visit ride_path(ride)
      expect(page).to_not have_content user.name

      sign_out
      sign_in_as owner
      visit ride_path(ride)

      within '.collection-item', text: user.name do
        expect(page).to have_content 'pending'
        click_button 'Accept'
      end

      expect(page).to have_current_path ride_path(ride)
      expect(page).to have_content I18n.t('participant.accepted')
      expect(page).to_not have_button 'Accept'

      sign_out
      sign_in_as user
      visit ride_path(ride)

      within '.participants' do
        within '.collection-item', text: user.name do
          expect(page).to have_content 'accepted'
          expect(page).to_not have_button 'Accept'
          expect(page).to_not have_button 'Reject'
        end
      end
    end
  end

  context 'user' do
    before do
      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
    end

    scenario 'will not see a link to accept' do
      expect(page).to_not have_button 'Accept'
    end
  end
end
