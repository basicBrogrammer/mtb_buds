# frozen_string_literal: true

class LoadNotificationsWorker
  include Sidekiq::Worker
  sidekiq_options retryable: false

  def perform(user_id, page)
    user = User.find(user_id)
    notifications = user.notifications.includes(:actor).page(page)
    notification_ids = notifications.pluck(:id)
    # TODO: move marking notifications to on click
    Notifications::MarkAsReadWorker.perform_async(notification_ids)

    NotificationsChannel.broadcast_to(
      user,
      message: NotificationsController.render_with_user(
        user,
        partial: 'notifications',
        locals: { notifications: notifications }
      )
    )
  end
end
