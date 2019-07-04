class TrailsController < ApplicationController
  def index
    @trails ||= MtbProjectRequest.new(
      params: {
        lat: coordinates[0],
        lon: coordinates[1]
      }
    ).call

    if params[:layout] == 'false'
      render layout: false
    end
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
