require 'rails_helper'

RSpec.describe CreateCommentNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:owner) { create(:user) }
  let(:ride) { create(:ride, user: owner) }
  let(:other_participant) { create(:participation, :accepted, ride: ride).user }
  let(:accepted_participant) { create(:participation, :accepted, ride: ride).user }
  let(:pending_participant) { create(:participation, :pending, ride: ride).user }
  let(:rejected_participant) { create(:participation, :rejected, ride: ride).user }

  context 'ride owner' do
    it 'will create a notification when a participant comments' do
      perform_enqueued_jobs  do
        expect(owner.notifications.count).to eq 0

        comment = create(:comment, ride: ride, user: other_participant)

        comment_notifications = owner.notifications.where(target_type: 'Comment')
        expect(comment_notifications.count).to eq 1
        note = comment_notifications.first
        expect(note.actor).to eq comment.user
        expect(note.target).to eq comment
      end
    end

    it 'will not create a notification when the owner comments' do 
      perform_enqueued_jobs  do
        expect(owner.notifications.count).to eq 0
        create(:comment, ride: ride, user: owner)

        expect(owner.notifications.count).to eq 0
      end
    end

    it 'will not create a notification if the user has comment notifications off' do
      owner.setting.update(comment_notifications: false)
      perform_enqueued_jobs  do
        expect(owner.notifications.count).to eq 0

        create(:comment, ride: ride, user: other_participant)

        comment_notifications = owner.notifications.where(target_type: 'Comment')
        expect(comment_notifications.count).to eq 0
      end
    end
  end

  context 'accepted participants' do 
    it 'will create a notification when a participant comments' do 
      perform_enqueued_jobs  do
        expect(accepted_participant.notifications.count).to eq 0
        comment = create(:comment, ride: ride, user: other_participant)

        expect(accepted_participant.notifications.count).to eq 1
        note = accepted_participant.notifications.first
        expect(note.actor).to eq comment.user
        expect(note.target).to eq comment
      end
    end

    it 'will create a notification when the owner comments' do
      perform_enqueued_jobs  do
        expect(accepted_participant.notifications.count).to eq 0

        comment = create(:comment, ride: ride, user: owner)

        expect(accepted_participant.notifications.count).to eq 1
        note = accepted_participant.notifications.first
        expect(note.actor).to eq comment.user
        expect(note.target).to eq comment
      end
    end

    it 'will not create a notification when the participant comments' do
      perform_enqueued_jobs  do
        expect(accepted_participant.notifications.count).to eq 0

        create(:comment, ride: ride, user: accepted_participant)

        expect(accepted_participant.notifications.count).to eq 0
      end
    end

    it 'will not create a notification if the user has comment notifications off' do
      accepted_participant.setting.update(comment_notifications: false)

      perform_enqueued_jobs  do
        expect(accepted_participant.notifications.count).to eq 0
        comment = create(:comment, ride: ride, user: other_participant)

        expect(accepted_participant.notifications.count).to eq 0
      end
    end
  end

  context 'pending participants'  do
    it 'will not create a notification when another participant comments' do
      perform_enqueued_jobs  do
        expect(pending_participant.notifications.count).to eq 0

        create(:comment, ride: ride, user: pending_participant)

        expect(pending_participant.notifications.count).to eq 0
      end
    end

    it 'will not create a notification when the owner comments' do
      perform_enqueued_jobs  do
        expect(pending_participant.notifications.count).to eq 0

        create(:comment, ride: ride, user: owner)

        expect(pending_participant.notifications.count).to eq 0
      end
    end
  end

  context 'rejected participants'  do
    it 'will not create a notification when another participant comments' do
      perform_enqueued_jobs  do
        expect(rejected_participant.notifications.count).to eq 0

        create(:comment, ride: ride, user: rejected_participant)

        expect(rejected_participant.notifications.count).to eq 0
      end
    end

    it 'will not create a notification when the owner comments' do
      perform_enqueued_jobs  do
        expect(rejected_participant.notifications.count).to eq 0

        create(:comment, ride: ride, user: owner)

        expect(rejected_participant.notifications.count).to eq 0
      end
    end
  end
end
