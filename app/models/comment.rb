class Comment < ApplicationRecord
  include DestroyNotifications
  belongs_to :ride
  belongs_to :user

  after_create_commit { CommentBroadcastJob.perform_now(self, ride) }
  after_create { CreateCommentNotificationJob.perform_later(self) }
end
