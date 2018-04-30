class Ride < ApplicationRecord
  default_scope { where('day >= ?', Date.today) }  
  belongs_to :user
  has_many :participations
  has_many :participants, through: :participations, source: :user

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

  def pretty_day
    day.strftime('%a %b %d')
  end

  def pretty_time
    time&.strftime("%l:%M %p")
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
