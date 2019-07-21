# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :ride
  belongs_to :user

  include DestroyNotifications
  after_create_commit do
    CommentBroadcastJob.perform_later(self, ride)
    Notifications::CommentCreatedJob.perform_later(self)
  end
end
