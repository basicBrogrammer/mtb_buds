# frozen_string_literal: true

class DestroyNotificationsWorker
  include Sidekiq::Worker

  def perform(target_id, target_type)
    Notification.where(target_id: target_id, target_type: target_type).destroy_all
  end
end
