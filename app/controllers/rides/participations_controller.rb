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
      participation = Participation.find_by(participation_params)

      if participation.accepted!
        redirect_to ride_path(participation_params[:ride_id]), notice: I18n.t('participant.accepted')
      else
        redirect_to ride_path(participation_params[:ride_id]), alert: I18n.t('participant.acceptance_failed')
      end
    end

    def destroy
      participation = Participation.find_by(participation_params)

      if participation.rejected!
        redirect_to ride_path(participation_params[:ride_id]), notice: I18n.t('participant.rejected')
      else
        redirect_to ride_path(participation_params[:ride_id]), alert: I18n.t('participant.rejection_failed')
      end
    end

    private

    def participation_params
      params.permit(:ride_id, :user_id, :id)
    end
  end
end
