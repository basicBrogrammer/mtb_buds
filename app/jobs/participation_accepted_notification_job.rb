class ParticipationAcceptedNotificationJob < ApplicationJob
  queue_as :default

  def perform(participation)
    if participation.accepted?
      ride = participation.ride
      Notification.create(
        actor: ride.user, 
        target: participation, 
        user: participation.user
      )
    end
  end
end
