feature 'Rides show page', :devise, :js do
  let(:user) { FactoryBot.create(:user) }
  let(:owner) { FactoryBot.create(:user) }

  let!(:ride) { create(:ride, user: owner, trail_id: '7019014') }
  let(:trail) { ride.trail }
  let!(:wrong_ride) { create(:ride, trail_id: '365066') }
  let(:wrong_trail) { wrong_ride.trail }

  context 'user' do
    before do
      sign_in_as(user)
      visit ride_path(ride)

      # verify user signed in
      within 'nav' do
        expect(page).to have_link 'Brraapp!'
        expect(page).to have_selector '.navbar-avatar'
      end
    end

    scenario 'the page should show the correct attributes in the card' do
      within '.card-title' do
        expect(page).to have_content trail['name']
      end

      within 'p', text: 'When' do
        expect(page).to have_content ride.pretty_day
        expect(page).to_not have_content ride.pretty_time
      end

      within 'p', text: 'Length' do
        expect(page).to have_content trail['length']
      end

      within 'p', text: 'Stars' do
        expect(page).to have_content ride.stars
      end

      within 'p', text: 'Difficulty' do
        expect(page).to have_content ride.difficulty
      end

      expect(page).to_not have_selector 'Interested'
    end

    scenario "the page should not show the wrong ride's info" do
      within '.card-title' do
        expect(page).to_not have_content wrong_trail['name']
      end
      expect(wrong_trail['name']).to_not be_empty

      expect(page).to_not have_selector 'Interested'
    end

    scenario 'should have the correct links above the ride card' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Destroy'
      expect(page).to have_link 'Back'
    end

    scenario 'the ride will have comments'
  end

  context 'owners' do
    before do
      sign_in_as(owner)
      visit ride_path(ride)

      # verify user signed in
      within 'nav' do
        expect(page).to have_link 'Brraapp!'
        expect(page).to have_selector '.navbar-avatar'
      end
    end

    scenario 'should have the correct links above the ride card' do
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Destroy'
      expect(page).to have_link 'Back'
    end

    scenario 'can destroy the ride' do
      expect(owner.rides.count).to eq 1

      click_link 'Destroy'
      confirm_dialog
      expect(page).to have_current_path rides_path

      expect(owner.rides.count).to eq 0
    end
  end

  context 'visitor' do
    before do
      visit ride_path(ride)

      # verify user is not signed in
      within 'nav' do
        expect(page).to have_link 'Sign in'
        expect(page).to have_link 'Sign up'
      end
    end

    scenario "clicking 'interested' will take me the registration path" do
      expect(page).to have_content I18n.t('devise.failure.unauthenticated')

      within 'main' do
        expect(page).to have_content 'Sign in'
        expect(page).to have_selector '.new_user'
      end
    end
  end
end
