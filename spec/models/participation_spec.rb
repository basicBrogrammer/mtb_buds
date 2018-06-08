require 'rails_helper'

RSpec.describe Participation, type: :model do
  include ActiveJob::TestHelper

  it 'enqueues the CreateParticipationNotificationJob job' do
    assert_enqueued_jobs 0

    assert_enqueued_with(job: CreateParticipationNotificationJob) do 
      create(:participation, id: 1)
    end

    assert_enqueued_jobs 1
  end

  it 'enqueues the ParticipationAcceptedNotificationJob job after being updated' do
    assert_enqueued_jobs 0
    participation = create(:participation, id: 1)
    assert_enqueued_jobs 1

    assert_enqueued_with(job: ParticipationAcceptedNotificationJob) do 
      participation.accepted!
    end

    assert_enqueued_jobs 2
  end
end
