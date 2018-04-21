feature 'Rides edit page', :devise, :js do
  let(:user) { FactoryBot.create(:user) }
  let(:owner) { FactoryBot.create(:user) }

  let!(:ride) { create(:ride, user: owner, trail_id: '7019014', time: Time.parse('12:00pm')) }
  let(:trail) { ride.trail }

  context 'user' do
    before do
      sign_in_as(user)
      visit edit_ride_path(ride)

      # verify user signed in
      within 'nav' do
        expect(page).to have_link 'Brraapp!'
        expect(page).to have_selector '.navbar-avatar'
      end
    end

    scenario 'cannot edit someone elses ride' do
      expect(page).to have_current_path root_path
      expect(page).to have_content I18n.t('unauthorized')
    end
  end

  context 'owners' do
    before do
      sign_in_as(owner)
      visit edit_ride_path(ride)

      # verify user signed in
      within 'nav' do
        expect(page).to have_link 'Brraapp!'
        expect(page).to have_selector '.navbar-avatar'
      end
    end

    scenario 'should be able to change the day and time but not the trail' do
      old_day = ride.day
      old_time = ride.time

      # fill out day
      find('#ride_day').click

      find("button[data-pika-day='#{old_day.day + 2}']").click
      find('.datepicker-done').click

      # fill out time
      find('#ride_time').click
      within '.timepicker-modal.open' do
        find('.timepicker-hours .timepicker-tick', text: 1, match: :first).click
        find('.timepicker-minutes .timepicker-tick', text: 2, match: :first).click
        click_on 'Ok'
      end

      expect(page).to_not have_selector '.ride_location'
      click_button 'Save'

      expect(page).to have_content I18n.t('rides.updated')
      expect(page).to have_current_path ride_path(ride)

      ride.reload
      expect(ride.day).to eq old_day + 2.days
      expect(ride.time.hour).to eq 13
      expect(ride.time.hour).to_not eq old_time.hour
      expect(ride.time.min).to eq 20
      expect(ride.time.min).to_not eq old_time.min
    end
  end

  context 'visitor' do
    before do
      visit edit_ride_path(ride)

      # verify user is not signed in
      within 'nav' do
        expect(page).to have_link 'Sign in'
        expect(page).to have_link 'Sign up'
      end
    end

    scenario 'cannot edit someone elses ride' do
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end
  end
end
