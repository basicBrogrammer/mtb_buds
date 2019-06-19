# frozen_string_literal: true

class RideSerializer
  include FastJsonapi::ObjectSerializer
  # set_type :movie  # optional
  # set_id :owner_id # optional
  attributes :id, :day, :time, :trail_id
  belongs_to :trail
  belongs_to :user
end
