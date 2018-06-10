require 'rails_helper'

RSpec.describe CreateParticipationNotificationJob, type: :job do
  let(:owner) { create(:user) }
  let(:ride) { create(:ride, user: owner) }
  let!(:participation) { create(:participation, :pending, ride: ride) }
  let!(:other_participation) { create(:participation, :accepted, ride: ride) }

  it 'will notify the owner when someone wants to join' do
    expect(owner.notifications.count).to eq 0

    CreateParticipationNotificationJob.new.perform(participation)

    expect(owner.notifications.count).to eq 1
  end

  it 'will not notify the owner when someone wants to join their participation notifications are off' do
    owner.setting.update(participation_notifications: false)
    expect(owner.notifications.count).to eq 0

    CreateParticipationNotificationJob.new.perform(participation)

    expect(owner.notifications.count).to eq 0
  end

  it 'will not notify partipants of a ride when someone wants to join' do
    expect(Notification.count).to eq 0 

    CreateParticipationNotificationJob.new.perform(participation)
    expect(Notification.count).to eq 1

    expect(owner.notifications.count).to eq 1
    expect(other_participation.user.notifications.count).to eq 0
  end
end
