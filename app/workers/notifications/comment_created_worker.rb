# frozen_string_literal: true

module Notifications
  class CommentCreatedWorker
    include Sidekiq::Worker

    def perform(id)
      comment = Comment.find(id)
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
        next unless participant.comment_notifications? && participant != comment.user

        Notification.create(
          actor: comment.user,
          target: comment,
          user: participant
        )
      end
    end
  end
end
