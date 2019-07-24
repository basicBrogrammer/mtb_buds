# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'on_destroy_delete_notifications'

  it 'enqueues CommentBroadcastWorker worker' do
    Sidekiq::Testing.fake! do
      expect(CommentBroadcastWorker.jobs.count).to eq 0
      expect { create(:comment) }.to change(CommentBroadcastWorker.jobs, :size).by 1
    end
  end
end
