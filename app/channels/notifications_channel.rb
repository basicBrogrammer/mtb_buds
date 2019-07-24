# frozen_string_literal: true

class NotificationsChannel < ApplicationCable::Channel
  def listen(data)
    stream_for current_user
    LoadNotificationsWorker.perform_async(
      current_user.id,
      data['page'],
    )
  end

  def unsubscribed
    stop_all_streams
  end
end
