# frozen_string_literal: true

class CommentBroadcastWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(comment_id, ride_id)
    comment = Comment.find comment_id
    ride = Ride.find ride_id
    ActionCable.server.broadcast(
      "CommentsChannel:#{ride.id}",
      message: render_comment(comment),
      ride_id: ride.id
    )
  end

  private

  def render_comment(comment)
    ApplicationController.render(
      partial: 'rides/comments/comment',
      locals: { comment: comment }
    )
  end
end
