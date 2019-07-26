# frozen_string_literal: true

module Notifications
  class ParticipationCreatedWorker
    include Sidekiq::Worker

    def perform(participation_id)
      participation = Participation.find participation_id
      ride = participation.ride
      if ride.user.participation_notifications?
        Notification.create(
          actor: participation.user,
          target: participation,
          user: ride.user
        )
      end
    end
  end
end
