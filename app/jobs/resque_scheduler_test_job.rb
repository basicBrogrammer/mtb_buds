# frozen_string_literal: true

class ResqueSchedulerTestJob
  @queue = :testing
  def self.perform
    ResqueTestMailer.testing(User.first).deliver_now
  end
end
