# frozen_string_literal: true

class Participation < ApplicationRecord
  include DestroyNotifications
  enum status: %i[pending accepted rejected]

  belongs_to :user
  belongs_to :ride

  after_create { Notifications::ParticipationCreatedWorker.perform_async(id) }
  after_update { Notifications::ParticipationAcceptedJob.perform_later(self) }
end
