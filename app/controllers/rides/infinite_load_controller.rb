# frozen_string_literal: true

module Rides
  class InfiniteLoadController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    layout false

    def index
      store_location_for(:user, rides_path)
      if search_params[:location]
        @rides = Ride.near(search_params[:location])
      else
        @rides = Ride.all
      end
    end

    private 

    def search_params
      params.permit(:location)
    end
    helper_method :search_params
  end
end
