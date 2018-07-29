# frozen_string_literal: true

module Mailers
  class UnreadNotificationsJob
    def self.perform
      self.slack_notification

      User.find_each(batch_size: 500) do |user|
        NotificationsMailer.unread(user).deliver_now if user.notifications.unread.any?
      end
    end

    def self.slack_notification
      notifier = Slack::Notifier.new ENV['slack_hook']
      notifier.ping("#{self} (#{Rails.env}) performing")
    end
  end
end
