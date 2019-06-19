# frozen_string_literal: true

feature 'User settings', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }

  context 'settings page' do
    before do
      sign_in_as user
      visit edit_user_registration_path
    end

    scenario 'The User can change their settings' do
      expect(user.setting.comment_notifications).to eq true
      expect(user.setting.participation_notifications).to eq true

      find('.collapsible-header', text: 'Notification Settings').click
      within '.edit_setting' do
        find('.setting_comment_notifications .lever').click
        click_on 'Update'
      end
      expect(page).to have_content I18n.t('settings.updated')

      user.reload
      expect(user.setting.comment_notifications).to eq false
      expect(user.setting.participation_notifications).to eq true

      find('.collapsible-header', text: 'Notification Settings').click
      within '.edit_setting' do
        find('.setting_participation_notifications .lever').click
        click_on 'Update'
      end
      expect(page).to have_content I18n.t('settings.updated')

      user.reload
      expect(user.setting.comment_notifications).to eq false
      expect(user.setting.participation_notifications).to eq false
    end
  end
end
