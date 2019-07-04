# frozen_string_literal: true

module RideHelper
  def ride_day_and_time(ride, user)
    result = ride.pretty_day
    if ride.user_id == user&.id || user&.accepted_participant?(ride)
      result << ", #{ride.pretty_time}"
    end
    result
  end

  def ride_difficulty_img(difficulty)
    "https://cdn.apstatic.com/img/diff/#{difficulty}.svg"
  end

  def ride_star_icons(index, number_of_stars)
    if index <= number_of_stars
      'star'
    elsif number_of_stars.ceil == index
      'star_half'
    else
      'star_border'
    end
  end

  def rider_pending?
    !rider_accepted?
  end

  def rider_accepted?
    @participations.pluck(:user_id).include? current_user.id
  end

  def join_able?
    @ride.user_id != current_user.id &&
      Participation.where(ride_id: @ride.id, user_id: current_user.id).none?
  end
end
