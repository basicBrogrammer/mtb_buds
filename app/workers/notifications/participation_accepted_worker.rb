# frozen_string_literal: true

module Notifications
  class ParticipationAcceptedWorker
    include Sidekiq::Worker

    def perform(participation_id)
      participation = Participation.find participation_id
      if participation.accepted? && participation.user.participation_notifications?
        ride = participation.ride
        Notification.create(
          actor: ride.user,
          target: participation,
          user: participation.user
        )
      end
    end
  end
end
