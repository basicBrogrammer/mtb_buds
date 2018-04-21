feature 'Participation', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }
  let!(:owner) { FactoryBot.create(:user) }

  let!(:ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:other_ride) { create(:ride, user: owner, trail_id: '7019014') }

  context 'owner' do
    before do
      sign_in_as(owner)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
    end

    scenario 'will not see a link to join' do
      expect(page).to_not have_link 'Join'
    end
  end

  context 'user' do
    before do
    end

    scenario 'can click a join link and the owner will be able to see a pending participant' do
      sign_in_as(owner)
      visit ride_path(ride)
      expect(page).to_not have_content user.name

      sign_out
      sign_in_as user
      visit ride_path(ride)

      within '.card-action' do
        click_button 'Join'
      end
      expect(page).to have_current_path ride_path(ride)
      expect(page).to have_content I18n.t('participation.requested')
      expect(page).to_not have_button 'Join'

      sign_out
      sign_in_as owner
      visit ride_path(ride)

      within '.participants' do
        within '.collection-item', text: user.name do
          expect(page).to have_content 'pending'
          expect(page).to have_button 'Accept'
          expect(page).to have_link 'Reject'
        end
      end
    end
  end
end
