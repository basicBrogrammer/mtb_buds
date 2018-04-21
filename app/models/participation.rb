class Participation < ApplicationRecord
  enum status: [:pending, :accepted, :rejected]
  belongs_to :user
  belongs_to :ride
end
