# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participation, type: :model do
  include ActiveJob::TestHelper

  it 'enqueues the Notifications::ParticipationCreatedJob job' do
    assert_enqueued_jobs 0, only: Notifications::ParticipationCreatedJob

    assert_enqueued_with(job: Notifications::ParticipationCreatedJob) do
      create(:participation, id: 1)
    end

    assert_enqueued_jobs 1, only: Notifications::ParticipationCreatedJob
  end

  it 'enqueues the Notifications::ParticipationCreatedJob job after being updated' do
    assert_enqueued_jobs 0, only: Notifications::ParticipationCreatedJob
    participation = create(:participation, id: 1)
    assert_enqueued_jobs 1, only: Notifications::ParticipationCreatedJob

    assert_enqueued_with(job: Notifications::ParticipationAcceptedJob) do
      participation.accepted!
    end

    assert_enqueued_jobs 1, only: Notifications::ParticipationAcceptedJob
  end
end
