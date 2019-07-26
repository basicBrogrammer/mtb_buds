# frozen_string_literal: true

module Notifications
  class MarkAsReadWorker
    include Sidekiq::Worker

    def perform(notification_ids)
      # guard is only necessary if outside Notification::InfiniteLoadController
      notifications = Notification.where(id: notification_ids)
      return nil if notifications.pluck(:user_id).uniq.many?

      Notification.read!(notifications.unread)
    end
  end
end
