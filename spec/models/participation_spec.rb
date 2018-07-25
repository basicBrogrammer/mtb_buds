require 'rails_helper'

RSpec.describe Participation, type: :model do
  include ActiveJob::TestHelper

  it 'enqueues the Notifications::ParticipationCreatedJob job' do
    assert_enqueued_jobs 0

    assert_enqueued_with(job: Notifications::ParticipationCreatedJob) do 
      create(:participation, id: 1)
    end

    assert_enqueued_jobs 1
  end

  it 'enqueues the Notifications::ParticipationAcceptedJob job after being updated' do
    assert_enqueued_jobs 0
    participation = create(:participation, id: 1)
    assert_enqueued_jobs 1

    assert_enqueued_with(job: Notifications::ParticipationAcceptedJob) do 
      participation.accepted!
    end

    assert_enqueued_jobs 2
  end
end
