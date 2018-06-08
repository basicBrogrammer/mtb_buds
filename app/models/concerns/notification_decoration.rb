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
      if self.target.pending?
        "<b>#{self.actor.name}</b> wants to join your ride."
      elsif self.target.accepted?
        "<b>#{self.actor.name}</b> added you to their ride."
      end
    else
      'Brrraaaapppp!!!'
    end
  end
end
