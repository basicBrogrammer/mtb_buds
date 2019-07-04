class DestroyNotificationsJob < ApplicationJob
  queue_as :default

  def perform(target:, target_type:)
    Notification.where(target_id: target, target_type: target_type).destroy_all
  end
end
