# frozen_string_literal: true

class MyRidesController < ApplicationController
  def index
    @my_rides = current_user.rides.active
    @my_participating_rides = Ride.active.where(id: ids_for_participating_rides)
  end

  private

  def ids_for_participating_rides
    current_user.participations.where(status: %i[pending accepted]).pluck(:ride_id)
  end
end
