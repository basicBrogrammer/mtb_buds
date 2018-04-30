feature 'My rides page', :devise, :js do
  let(:user) { create(:user) }

  describe 'navigation' do 
    scenario 'visitors cannot visit' do
      visit root_path

      within 'nav' do 
        expect(page).to_not have_link 'My Rides'
      end
      visit my_rides_path

      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
      expect(page).to have_current_path new_user_session_path
    end

    scenario 'there is a link in the navbar' do
      sign_in_as user
      visit root_path

      within 'nav' do 
        click_link 'My Rides'
      end

      expect(page).to have_current_path my_rides_path
    end
  end

  describe 'rides I created' do
    let!(:future_ride) { create(:ride, user: user, trail_id: '7019014', day: Date.tomorrow) }
    let!(:past_ride) { create(:ride, user: user, trail_id: '365066', day: Date.today - 1.days) }

    before do
      sign_in_as user
      visit my_rides_path
    end

    scenario 'future rides display' do
      expect(page).to have_content future_ride.trail['name']
      expect(page).to have_content future_ride.pretty_day
      expect(page).to have_content future_ride.pretty_time
    end

    scenario 'past rides do not display' do
      expect(page).to_not have_content past_ride.trail['name']
      expect(page).to_not have_content past_ride.pretty_day
      expect(page).to_not have_content past_ride.pretty_time
    end
  end

  describe "rides I'm participating in" do
    let!(:future_participating_ride) do
      create(:participation, :accepted,
        ride: create(:ride, trail_id: '7019014'),
        user: user).ride
    end

    let!(:past_participating_ride) do
       create(:participation, :accepted,
         ride: create(:ride, trail_id: '365066', day: Date.today - 1.day),
         user: user).ride
    end

    let!(:pending_participating_ride) do
       create(:participation, :pending,
         ride: create(:ride, trail_id: '2421789'),
         user: user).ride
    end

    let!(:rejected_participating_ride) do
       create(:participation, :rejected,
         ride: create(:ride, trail_id: '342104'),
         user: user).ride
    end

    before do
      sign_in_as user
      visit my_rides_path
    end

    scenario 'future rides display' do
      expect(page).to have_content future_participating_ride.trail['name']
      expect(page).to have_content future_participating_ride.pretty_day
      expect(page).to have_content future_participating_ride.pretty_time
    end

    scenario 'past rides do not display' do
      expect(page).to_not have_content past_participating_ride.trail['name']
      expect(page).to_not have_content past_participating_ride.pretty_day
      expect(page).to_not have_content past_participating_ride.pretty_time
    end

    scenario 'pending rides display' do
      expect(page).to have_content pending_participating_ride.trail['name']
      expect(page).to have_content pending_participating_ride.pretty_day
      expect(page).to_not have_content pending_participating_ride.pretty_time
    end

    scenario 'rejected rides do not display' do
      expect(page).to_not have_content rejected_participating_ride.trail['name']
      expect(page).to_not have_content rejected_participating_ride.pretty_day
      expect(page).to_not have_content rejected_participating_ride.pretty_time
    end
  end

  describe 'other peoples rides' do
    let!(:other_ride) { create(:ride, trail_id: '7019014') }

    before do
      sign_in_as user
      visit my_rides_path
    end

    scenario 'do not display' do
      within '.main-page-grid', text: 'My rides' do
        expect(page).to have_content "You haven't created any future rides yet."
        expect(page).to_not have_content other_ride.trail['name']
      end
    end
  end

  describe 'other peoples participating rides' do
    let!(:others_participating_ride) do
      create(:participation, :accepted,
        ride: create(:ride, trail_id: '7019014')).ride
    end
    before do
      sign_in_as user
      visit my_rides_path
    end
    scenario 'do not display' do
      within '.main-page-grid', text: 'My participating rides' do
        expect(page).to have_content "You arent't participating in any upcoming rides."
        expect(page).to_not have_content others_participating_ride.trail['name']
      end
    end
  end
end
