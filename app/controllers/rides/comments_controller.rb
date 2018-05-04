# frozen_string_literal: true

module Rides
  class CommentsController < ApplicationController
    layout false
    def index
      store_location_for(:user, rides_path)
      @ride = Ride.find(params[:ride_id])
      @comments = @ride.comments
    end
  end
end
