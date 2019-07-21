# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::MarkAsReadWorker, type: :worker do
  let(:user) { create(:user) }
  let!(:users_unread_notifications) do
    create_list(:notification, 3, :comment_target, user: user)
  end
  let!(:users_read_notifications) do
    create_list(:notification, 3, :comment_target, user: user, read_at: Time.zone.yesterday.beginning_of_day)
  end

  let(:other_user) { create(:user) }
  let!(:other_users_notifications) do
    create_list(:notification, 3, :comment_target, user: other_user)
  end

  it "marks the user's unread notifications as read" do
    expect(user.notifications.count).to eq 6
    expect(Notification.unread_count(user)).to eq 3

    call_worker user.notifications

    expect(user.notifications.count).to eq 6
    expect(Notification.unread_count(user)).to eq 0

    users_unread_notifications.each do |note|
      note.reload
      expect(note.read?).to eq true
    end
  end

  it "doesn't touch the user's previously read notifications as read" do
    users_read_notifications.each do |note|
      expect(note.read_at).to be < Time.zone.now.beginning_of_day
      expect(note.read_at).to be > Time.zone.now.beginning_of_day - 2.days
    end

    call_worker user.notifications

    users_read_notifications.each do |note|
      note.reload
      expect(note.read_at).to be < Time.zone.now.beginning_of_day
      expect(note.read_at).to be > Time.zone.now.beginning_of_day - 2.days
    end
  end
  it "doesn't marks the other user's unread notifications as read" do
    other_users_notifications.each do |note|
      expect(note.read?).to eq false
    end

    call_worker user.notifications

    other_users_notifications.each do |note|
      note.reload
      expect(note.read?).to eq false
    end

    call_worker Notification.all

    other_users_notifications.each do |note|
      note.reload
      expect(note.read?).to eq false
    end
  end

  def call_worker(notifications)
    ids = notifications.pluck(:id)
    Notifications::MarkAsReadWorker.new.perform(ids)
  end
end
