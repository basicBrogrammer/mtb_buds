# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
require 'factory_bot_rails'
class NotificationsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/unread
  def unread
    user = User.find_by(email: 'user3@example.com')

    NotificationsMailer.unread(user)
  end
end
