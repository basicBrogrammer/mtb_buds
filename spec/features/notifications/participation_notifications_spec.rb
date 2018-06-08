feature 'Participation Notifications', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }
  let!(:ride) { create(:ride, :boulder) }
  let!(:participation) { create(:participation, ride: ride) }
  let!(:my_participation_notification) { create(:notification, user: user, target: participation) }
  let!(:other_users_participation_notification) { create(:notification, target: create(:participation, ride: create(:ride, :moab))) }

  context 'comments' do
    before do 
      sign_in_as user
      visit notifications_path
    end

    scenario 'I will see my participation notifications' do
      expect(page).to have_content notification_title(my_participation_notification)
      expect(page).to have_content my_participation_notification.target.ride.name
      expect(all('.notification--participation').count).to eq 1
      expect(all('.notification--comment').count).to eq 0

      find('.notification--participation').click
      expect(page).to have_current_path ride_path(ride)
    end

    scenario "I will not see other people's participation notifications" do
      expect(page).to_not have_content notification_title(other_users_participation_notification)
      expect(page).to_not have_content other_users_participation_notification.target.ride.name
    end

    def notification_title(notification) 
      "#{notification.actor.name} wants to join your ride."
    end
  end
end
