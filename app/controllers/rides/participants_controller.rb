# frozen_string_literal: true

module Rides
  class ParticipantsController < ApplicationController
    # skip_before_action :authenticate_user!, only: :index
    layout false

    def index
      @ride = Ride.find(params[:ride_id])
      if current_user == @ride.user
        @participations = @ride.participations.includes(:user)
      else
        @participations = @ride.participations.accepted.includes(:user)
      end
      render partial: 'rides/participations'
    end

    private

    def participations
      @participations
    end
    helper_method :participations
  end
end
