# frozen_string_literal: true

module DestroyNotifications
  extend ActiveSupport::Concern
  included do
    before_destroy :destory_notifications
  end

  private

  def destory_notifications
    DestroyNotificationsJob.perform_later(target: id, target_type: model_name.human)
  end
end
