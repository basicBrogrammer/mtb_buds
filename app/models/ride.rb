class Ride < ApplicationRecord
  belongs_to :user
  validates_presence_of :day, :time, :trail_id
  # TODO: create a service object to background this
  before_create :save_mtb_projec_data
  # TODO: Geocode
  
  def trail
    @trail ||= MtbProjectRequest.new(
      endpoint: 'get-trails-by-id',
      params: { ids: self.trail_id }
    ).call&.first
  end

  private

  def save_mtb_projec_data
    self.assign_attributes(
      longitude: trail['longitude'],
      latitude: trail['latitude'],
      location: trail['location'],
      difficulty: trail['difficulty'],
      stars: trail['stars']
    )
  end
end
