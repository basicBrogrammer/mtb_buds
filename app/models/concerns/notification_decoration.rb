# frozen_string_literal: true

module NotificationDecoration
  extend ActiveSupport::Concern

  def comment
    target
  end

  def ride
    target_type == 'Ride' ? target : target.ride
  end

  def title
    case target_type
    when 'Comment'
      "<b>#{actor.name}</b> commented on your ride."
    when 'Participation'
      if target.pending?
        "<b>#{actor.name}</b> wants to join your ride."
      elsif target.accepted?
        "<b>#{actor.name}</b> added you to their ride."
      end
    when 'Ride'
      "<b>#{actor.name}</b> just posted a ride near you."
    else
      'Brrraaaapppp!!!'
    end
  end
end
