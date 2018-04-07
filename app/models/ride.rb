class Ride < ApplicationRecord
  belongs_to :user
  validates_presence_of :longitude, :latitude, :day, :time, :trail_id
end
