require 'rails_helper'

RSpec.describe Participation, type: :model do
  include ActiveJob::TestHelper

  it 'enqueues the CreateParticipationNotificationJob job' do
    assert_enqueued_jobs 0

    assert_enqueued_with(job: CreateParticipationNotificationJob) do 
      participation = create(:participation, id: 1)
    end

    assert_enqueued_jobs 1
  end
end
