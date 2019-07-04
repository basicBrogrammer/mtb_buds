# frozen_string_literal: true

class MtbProjectRequest
  ROOT_URL = 'https://www.mtbproject.com/data'
  VALID_END_POINTS = %w[get-trails get-trails-by-id].freeze
  # https://www.mtbproject.com/data/get-trails?
  #   ?lat=40.0274&lon=-105.2519&maxDistance=10&maxResult
  # https://www.mtbproject.com/data/get-trails-by-id
  #   ?ids=4670265,3671983,7015764,7003838,157369
  attr_reader :endpoint, :params
  def initialize(endpoint: 'get-trails', params: {})
    if VALID_END_POINTS.include? endpoint
      @params = params
      @endpoint = endpoint
    else
      raise "Invalid endpoint: #{endpoint}. Accepted endpoints: #{VALID_END_POINTS}"
    end
  end

  def call
    response = get_json
    JSON.parse(response.body)['trails']
  end

  def get_json
    Rails.cache.fetch(cache_key, expires_in: expires_in) do
      client.get do |req| # GET http://sushi.com/search?page=2&limit=100
        req.headers['Content-Type'] = 'application/json'
        req.url endpoint
        req.params = get_params
      end
    end
  end

  def get_params
    params.merge(
      key: ENV['mtb_project_key'],
      maxDistance: 50,
      maxResults: 250,
      sort: 'distance'
    )
  end

  def client
    @connection ||= Faraday.new(url: ROOT_URL)
  end

  private

  def cache_key
    "[GET]mtb/#{endpoint}: #{params.to_query}"
  end

  def expires_in
    ENV.fetch('mtb_expires_in', 30.days.to_s)
  end
end
