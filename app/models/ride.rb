class Ride < ApplicationRecord
  scope :active, -> { where('day >= ?', Date.today) }
  geocoded_by :location

  belongs_to :user
  # TODO: add participations_counter_cache
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
  # TODO: add comment_counter_cache
  has_many :comments, dependent: :destroy

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

  def name
    trail['name']
  end

  def owner?(user)
    user&.id == user_id
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
