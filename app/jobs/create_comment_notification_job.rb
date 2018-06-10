class CreateCommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ride = comment.ride
    # Do something later
    if ride.user.comment_notifications? && ride.user != comment.user
      Notification.create(
        actor: comment.user, 
        target: comment,
        user: ride.user
      )
    end

    ride.participations.accepted.each do |participation|
      participant = participation.user
      if participant.comment_notifications? && participant != comment.user
        Notification.create(
          actor: comment.user, 
          target: comment,
          user: participant
        )
      end
    end
  end
end
