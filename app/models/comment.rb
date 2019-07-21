# frozen_string_literal: true

class Comment < ApplicationRecord
  include DestroyNotifications

  belongs_to :ride
  belongs_to :user

  after_create_commit do
    CommentBroadcastWorker.perform_async(id, ride_id)
    Notifications::CommentCreatedWorker.perform_async(id)
  end
end
