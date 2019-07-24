# frozen_string_literal: true

module Notifications
  class RideCreatedWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'low'

    def perform(ride_id)
      ride = Ride.find ride_id
      User.near(ride.location, 150).each do |user|
        next if user == ride.user || !user.ride_notifications?

        Notification.create(
          actor: ride.user,
          target: ride,
          user: user
        )
      end
    end
  end
end
