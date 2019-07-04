class Notification < ApplicationRecord
  include NotificationDecoration
  belongs_to :actor, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  # types: 
  #   Comments

  scope :unread, -> { where(read_at: nil) }

  def read?
    self.read_at.present?
  end

  # TODO: background job
  def self.read!(ids = [])
    return if ids.blank?
    Notification.where(id: ids).update_all(read_at: Time.now)
  end

  def self.unread_count(user)
    Notification.where(user: user).unread.count
  end
end
