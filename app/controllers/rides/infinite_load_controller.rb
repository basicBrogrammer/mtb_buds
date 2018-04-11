# frozen_string_literal: true

module Rides
  class InfiniteLoadController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    layout false

    def index
      store_location_for(:user, rides_path)
      @rides = Ride.all
    end
  end
end
