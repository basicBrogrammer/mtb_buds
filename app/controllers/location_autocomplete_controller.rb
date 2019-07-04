class LocationAutocompleteController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  respond_to :json
  def index
    render json: location_results
  end

  private

  def search_param
    @search_param ||= params.permit(:q)[:q]
  end

  def client
    @client ||= GooglePlaces::Client.new(ENV['google_places'])
  end

  def predictions
    client.predictions_by_input(search_param, types: '(cities)')
  end

  def location_results
    predictions.map do |prediction|
      { id: prediction.description, text: prediction.description }
    end
  end
end
