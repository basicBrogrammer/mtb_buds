# frozen_string_literal: true

module Mailers
  class UnreadNotificationsJob
    def self.perform
      # TODO add slack notification
      User.find_each(batch_size: 500) do |user|
        NotificationsMailer.unread(user).deliver_now
      end
    end
  end
end
