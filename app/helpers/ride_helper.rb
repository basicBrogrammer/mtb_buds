module RideHelper
  def ride_day_and_time(ride, user)
    result = ride.pretty_day
    if ride.user_id == user&.id || user&.accepted_participant?(ride)
      result << ", #{ride.pretty_time}"
    end
    result
  end
end
