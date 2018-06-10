class ParticipationAcceptedNotificationJob < ApplicationJob
  queue_as :default

  def perform(participation)
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
