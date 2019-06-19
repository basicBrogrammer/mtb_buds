# frozen_string_literal: true

class TrailSerializer
  include FastJsonapi::ObjectSerializer
  # set_type :movie  # optional
  # set_id :owner_id # optional
  attributes :id, :name, :type, :summary, :difficulty, :stars, :starVotes,
    :location, :url, :imgSqSmall, :imgSmall, :imgSmallMed, :imgMedium, :length,
    :ascent, :descent, :high, :low, :longitude, :latitude, :conditionStatus,
    :conditionDetails, :conditionDate
end
