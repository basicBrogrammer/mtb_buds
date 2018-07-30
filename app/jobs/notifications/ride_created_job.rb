# frozen_string_literal: true

module Notifications
  class RideCreatedJob < ApplicationJob
    queue_as :default

    def perform(ride)
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
