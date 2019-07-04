module NotificationHelper
  def notification_css_class(notification)
    read_or_not = notification.read? ? 'read' : 'unread'
    "notification--#{notification.target_type.downcase} #{read_or_not}"
  end
end
