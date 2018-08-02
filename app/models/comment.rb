class Comment < ApplicationRecord
  belongs_to :ride
  belongs_to :user

  include DestroyNotifications
  # TODO: change to perform_later
  after_create_commit { CommentBroadcastJob.perform_now(self, ride) }
  after_create { Notifications::CommentCreatedJob.perform_later(self) }
end
