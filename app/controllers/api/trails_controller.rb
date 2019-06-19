# frozen_string_literal: true

module Api
  class TrailsController < BaseController
    def index
      trails ||= MtbProjectRequest.new(
        params: {
          lat: coordinates[0],
          lon: coordinates[1]
        }
      ).call

      render json: TrailSerializer.new(trails)
    end

    private

    def search_params
      params[:location]
    end

    def coordinates
      # returns [lat, lon]
      @coordinates ||= Geocoder.coordinates(search_params)
    end
  end
end
