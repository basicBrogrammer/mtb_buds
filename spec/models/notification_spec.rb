# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  include ActiveJob::TestHelper
  describe '#target' do
    it 'will be deleted if target is deleted' do
      perform_enqueued_jobs do
        target = create(:comment) # creates an async notification

        expect(Notification.count).to eq 1
        target.destroy
        expect(Notification.count).to eq 0
      end
    end
  end
end
