# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Notifications::RideCreatedWorker, type: :worker do
  let!(:owner) { create(:user, :boulder) }
  let!(:user_within_50mi) { create(:user, :boulder) }
  let!(:user_within_100mi) { create(:user, :breckenridge) }
  let!(:user_within_150mi) { create(:user, :aspen) }
  let!(:user_within_200mi) { create(:user, :grand_junction) }
  let!(:user_unsubscribed_to_ride_notifications) { create(:user, :boulder) }
  let(:ride) { create(:ride, user: owner) }

  context 'perform' do
    it 'will not create a notification for the owner' do
      expect(owner.notifications.count).to eq 0
      create_ride_and_worker
      expect(owner.notifications.count).to eq 0
    end

    it 'will create a notification for a rider within 50 mi' do
      expect(user_within_50mi.notifications.count).to eq 0
      create_ride_and_worker
      expect(user_within_50mi.notifications.count).to eq 1
    end

    it 'will create a notification for a rider within 100 mi' do
      expect(user_within_100mi.notifications.count).to eq 0
      create_ride_and_worker
      expect(user_within_100mi.notifications.count).to eq 1
    end

    it 'will create a notification for a rider within 150 mi' do
      expect(user_within_150mi.notifications.count).to eq 0
      create_ride_and_worker
      expect(user_within_150mi.notifications.count).to eq 1
    end

    it 'will not create a notification for a rider over 200 mi' do
      expect(user_within_200mi.notifications.count).to eq 0
      create_ride_and_worker
      expect(user_within_200mi.notifications.count).to eq 0
    end

    it 'will not create a notification for a rider who is unsubscribed from ride notes within 50 mi' do
      user_unsubscribed_to_ride_notifications.setting.update(ride_notifications: false)
      expect(user_unsubscribed_to_ride_notifications.notifications.count).to eq 0
      create_ride_and_worker
      expect(user_unsubscribed_to_ride_notifications.notifications.count).to eq 0
    end
  end

  def create_ride_and_worker
    ride
  end
end
