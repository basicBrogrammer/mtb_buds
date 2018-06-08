class Participation < ApplicationRecord
  enum status: [:pending, :accepted, :rejected]
  belongs_to :user
  belongs_to :ride
  after_create { CreateParticipationNotificationJob.perform_later(self) }
  after_update { ParticipationAcceptedNotificationJob.perform_later(self) }
end
