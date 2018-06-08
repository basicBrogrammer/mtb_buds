feature 'Participation Notifications', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }
  let!(:ride) { create(:ride, :boulder) }
  let!(:participation) { create(:participation, ride: ride) }
  let!(:my_participation_notification) { create(:notification, user: user, target: participation) }
  let!(:other_users_participation_notification) { create(:notification, target: create(:participation, ride: create(:ride, :moab))) }

  let(:my_participation) { create(:participation, :accepted, user: user) }
  let(:other_ride) { my_participation.ride }
  let!(:accpted_participation_notification) do
    create(:notification, user: user, target: my_participation, actor: other_ride.user) 
  end

  context 'comments' do
    before do 
      sign_in_as user
      visit notifications_path
    end

    scenario 'I will see my participation notifications' do
      target_notification_title = notification_title(my_participation_notification)
      expect(page).to have_content target_notification_title
      expect(page).to have_content my_participation_notification.target.ride.name

      find('.notification--participation', text: target_notification_title).click
      expect(page).to have_current_path ride_path(ride)
    end

    scenario "I will not see other people's participation notifications" do
      expect(page).to_not have_content notification_title(other_users_participation_notification)
      expect(page).to_not have_content other_users_participation_notification.target.ride.name
    end

    scenario 'I will see when the owner accepts my join request' do
      target_notification_title = "#{other_ride.user.name} added you to their ride."

      expect(page).to have_content target_notification_title
      expect(page).to have_content my_participation_notification.target.ride.name

      find('.notification--participation', text: target_notification_title).click
      expect(page).to have_current_path ride_path(other_ride)
    end

    def notification_title(notification) 
      "#{notification.actor.name} wants to join your ride."
    end
  end
end
