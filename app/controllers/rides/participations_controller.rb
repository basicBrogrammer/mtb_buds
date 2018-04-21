module Rides
  class ParticipationsController < ApplicationController
    def create
      participation = Participation.create(
        participation_params.merge(status: 'pending')
      )

      if participation.save
        redirect_to ride_path(participation_params[:ride_id]), notice: I18n.t('participation.requested')
      else
        redirect_to ride_path(participation_params[:ride_id]), alert: I18n.t('participation.failed')
      end
    end

    def update

    end

    def destroy
    end

    private

    def participation_params
      params.permit(:ride_id, :user_id)
    end
  end
end
