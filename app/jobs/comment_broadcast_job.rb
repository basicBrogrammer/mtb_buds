class CommentBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment, ride)
    # Do something later
    broadcast_to_participants(comment, ride)
    broadcast_to_owner(comment, ride)
  end

  private 

  def broadcast_to_participants(comment, ride)
    ride.participations.accepted.each do |participation|
      ActionCable.server.broadcast(
        "comments-#{participation.user_id}",
        message: render_comment(comment),
        ride_id: ride.id
      )
    end
  end

  def broadcast_to_owner(comment, ride)
      ActionCable.server.broadcast(
        "comments-#{ride.user_id}",
        message: render_comment(comment),
        ride_id: ride.id
      )
  end

  def render_comment(comment)
    ApplicationController.render(
      partial: 'rides/comments/comment',
      locals: { comment: comment }
    )
  end
end
