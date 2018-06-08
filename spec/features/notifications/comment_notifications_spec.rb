feature 'Comment Notifications', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }
  let!(:ride) { create(:ride, trail_id: '7019014') }
  let!(:comment) { create(:comment, ride: ride) }
  let!(:my_comment_notification) { create(:notification, user: user, target: comment) }
  let!(:other_users_comment_notification) { create(:notification, :comment_target) }

  context 'comments' do
    before do 
      sign_in_as user
      visit notifications_path
    end

    scenario 'I will see my comment notifications' do
      expect(page).to have_content notification_title(my_comment_notification)
      expect(page).to have_content my_comment_notification.comment.body
      expect(all('.notification--participation').count).to eq 0
      expect(all('.notification--comment').count).to eq 1

      find('.notification--comment').click
      expect(page).to have_current_path ride_path(ride)
    end

    scenario "I will not see other people's comment notifications" do
      expect(page).to_not have_content notification_title(other_users_comment_notification)
      expect(page).to_not have_content other_users_comment_notification.comment.body
    end

    def notification_title(notification) 
      "#{notification.actor.name} commented on your ride."
    end
  end
end
