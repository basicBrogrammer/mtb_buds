# frozen_string_literal: true

module Mailers
  class UnreadNotificationsJob
    def self.perform
      new_emails = 0
      User.find_each(batch_size: 500) do |user|
        if user.notifications.unread.any?
          NotificationsMailer.unread(user).deliver_now
          new_emails +=1
        end
      end

      self.slack_notification(new_emails)
    end

    def self.slack_notification(new_emails)
      notifier = Slack::Notifier.new ENV['slack_hook']
      notifier.ping("#{self} (#{Rails.env}) sent ##{new_emails} new emails.")
    end
  end
end
