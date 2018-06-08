module NotificationDecoration
  extend ActiveSupport::Concern
  included do 
    delegate :ride, to: :target
  end

  def comment
    self.target
  end

  def title
    case self.target_type
    when 'Comment'
      "<b>#{self.actor.name}</b> commented on your ride."
    when 'Participation'
      "<b>#{self.actor.name}</b> wants to join your ride."
    else
      'Brrraaaapppp!!!'
    end
  end
end
