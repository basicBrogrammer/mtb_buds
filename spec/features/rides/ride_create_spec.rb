feature 'Rides new page', :devise, :js do
  let(:user) { FactoryBot.create(:user) }

  context 'user' do
    before do
      sign_in_as(user)
      visit root_path

      # verify user signed in
      within 'nav' do
        expect(page).to have_link 'Brraapp!'
        expect(page).to have_selector '.navbar-avatar'
      end
    end

    scenario 'should be able to create a ride from the home page' do
      expect(Ride.count).to eq 0
      within 'nav' do
        click_link 'Brraapp!'
      end
      expect(page).to have_current_path new_ride_path

      # fill out day
      find('#ride_day').click

      find("button[data-pika-day='#{Time.zone.now.end_of_week.day - 1}']").click
      find('.datepicker-done').click

      # fill out time
      find('#ride_time').click
      within '.timepicker-modal.open' do
        find('.timepicker-hours .timepicker-tick', text: 1, match: :first).click
        find('.timepicker-minutes .timepicker-tick', text: 2, match: :first).click
        click_on 'Ok'
      end

      select2_search('Bou', choice: 'Boulder, CO, USA', from: '.ride_location')

      # expect(page).to have_selector '.preloader-wrapper'
      # expect(page).to_not have_selector '.preloader-wrapper'

      within '.card.trail', match: :first do
        click_button 'Select'
      end

      expect(page).to have_content I18n.t('rides.created')
      expect(Ride.count).to eq 1
      ride = Ride.first
      expect(page).to have_current_path ride_path(ride)

      within 'p', text: 'When' do
        expect(page).to have_content ride.pretty_day
        expect(page).to have_content ride.pretty_time
      end

      within 'p', text: 'Length' do
        expect(page).to have_content ride.trail['length']
      end

      within 'p', text: 'Stars' do
        expect(page).to have_content ride.stars
      end

      within 'p', text: 'Difficulty' do
        expect(page).to have_content ride.difficulty
      end
    end

    scenario 'can filter rides' do
      within 'nav' do
        click_link 'Brraapp!'
      end

      select2_search('fort collin', choice: 'Fort Collins, CO, USA', from: '.ride_location')
      filter_input = find('#filter-trail')

      expect(all('.trail').count).to eq 250

      filter_input.send_keys('blue sky')

      expect(all('.trail').count).to eq 2
      all('.trail').each do |trail_card|
        expect(trail_card.text.downcase).to include 'blue sky'
      end

      filter_input.set('')
      filter_input.send_keys(:backspace)

      expect(all('.trail').count).to eq 250
    end

    scenario 'validations' do
      visit new_ride_path
      click_button 'Save'
      within '#error_explanation' do
        %w[Day Time Trail].each do |attribute|
          expect(page).to have_content "#{attribute} can't be blank"
        end
      end

      within '.ride_day' do
        expect(page).to have_content "can't be blank"
      end

      within '.ride_time' do
        expect(page).to have_content "can't be blank"
      end

      within '.ride_trail_id' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  context 'visitor' do
    before do
      visit new_ride_path

      # verify user is not signed in
      within 'nav' do
        expect(page).to have_link 'Sign in'
        expect(page).to have_link 'Sign up'
      end
    end

    scenario 'cannot create a ride' do
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end
  end
end
