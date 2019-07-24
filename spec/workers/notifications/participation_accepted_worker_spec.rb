# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Notifications::ParticipationAcceptedWorker, :sidekiq_fake, type: :worker do
  let(:owner) { create(:user) }
  let(:ride) { create(:ride, user: owner) }
  let(:other_participant) { create(:participation, :accepted, ride: ride).user }
  let!(:accepted_participation) { create(:participation, :accepted, ride: ride) }
  let!(:pending_participation) { create(:participation, :pending, ride: ride) }
  let!(:rejected_participation) { create(:participation, :rejected, ride: ride) }

  context 'accepted' do
    it 'will notify the accepted partipant of a ride' do
      call_worker accepted_participation
      expect(accepted_participation.user.notifications.count).to eq 1
      notification = accepted_participation.user.notifications.first
      expect(accepted_participation.ride.user).to eq notification.actor
    end
    it 'will not notify the accepted partipant of a ride if the users notifications are off' do
      accepted_participation.user.setting.update(participation_notifications: false)

      call_worker(accepted_participation, notification_count: 0)

      expect(accepted_participation.user.notifications.count).to eq 0
    end
    it 'will not notify the owner of a ride' do
      call_worker accepted_participation
      expect(owner.notifications.count).to eq 0
    end
    it 'will not notify partipants of a ride' do
      call_worker accepted_participation
      expect(other_participant.notifications.count).to eq 0
    end
  end

  context 'pending' do
    it 'will not create any notifications' do
      call_worker(pending_participation, notification_count: 0)
    end
  end
  context 'rejected' do
    it 'will not create any notifications' do
      call_worker(rejected_participation, notification_count: 0)
    end
  end

  def call_worker(participation, notification_count: 1)
    expect(Notification.count).to eq 0

    Notifications::ParticipationAcceptedWorker.new.perform(participation.id)
    expect(Notification.count).to eq notification_count
  end
end
