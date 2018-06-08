class CreateParticipationNotificationJob < ApplicationJob
  queue_as :default

  def perform(participation)
    ride = participation.ride
    Notification.create(
      actor: participation.user, 
      target: participation, 
      user: ride.user
    )
  end
end
