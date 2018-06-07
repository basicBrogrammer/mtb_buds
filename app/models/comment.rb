class Comment < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  has_many :notifications, as: :action, dependent: :destroy

  after_create_commit { CommentBroadcastJob.perform_later(self, ride) }
  after_create { CreateCommentNotificationJob.perform_later(self) }
end
