# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participation, type: :model do
  it_behaves_like 'on_destroy_delete_notifications'

  it 'enqueues the Notifications::ParticipationCreatedJob job', :sidekiq_fake do
    expect(Notifications::ParticipationCreatedWorker.jobs.size).to eq 0

    expect { create(:participation, id: 1) }.to change(Notifications::ParticipationCreatedWorker.jobs, :size).by(1)

    expect(Notifications::ParticipationCreatedWorker.jobs.size).to eq 1
  end

  it 'enqueues the Notifications::ParticipationCreatedJob job after being updated', :sidekiq_fake do
    expect(Notifications::ParticipationCreatedWorker.jobs.size).to eq 0
    participation = create(:participation, id: 1)
    expect(Notifications::ParticipationCreatedWorker.jobs.size).to eq 1

    expect(Notifications::ParticipationAcceptedWorker.jobs.size).to eq 0
    expect { participation.accepted! }.to change(Notifications::ParticipationCreatedWorker.jobs, :size).by(0)

    expect(Notifications::ParticipationAcceptedWorker.jobs.size).to eq 1
  end
end
