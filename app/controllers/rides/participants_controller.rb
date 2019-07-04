# frozen_string_literal: true

module Rides
  class ParticipantsController < ApplicationController
    # skip_before_action :authenticate_user!, only: :index
    layout false

    def index
      @ride = Ride.find(params[:ride_id])
      @participations = if current_user == @ride.user
                          @ride.participations.includes(:user)
                        else
                          @ride.participations.accepted.includes(:user)
                        end
      render partial: 'rides/participations'
    end

    private

    attr_reader :participations
    helper_method :participations
  end
end
