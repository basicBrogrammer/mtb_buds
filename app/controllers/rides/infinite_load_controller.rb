# frozen_string_literal: true

module Rides
  class InfiniteLoadController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    layout false

    def index
      store_location_for(:user, rides_path)
      @rides = if search_params[:location]
                 Ride.active.near(search_params[:location]).page(params[:page])
               else
                 Ride.active.all.page(params[:page])
               end
    end

    private

    def search_params
      params.permit(:location)
    end
    helper_method :search_params
  end
end
