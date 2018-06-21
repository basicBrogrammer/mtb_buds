module DestroyNotifications
  extend ActiveSupport::Concern
  included do 
    before_destroy :destory_notifications
  end

  private 

  def destory_notifications
    DestroyNotificationsJob.perform_later(target: self.id, target_type: self.model_name.human)
  end
end
