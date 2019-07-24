# frozen_string_literal: true

class RidesChannel < ApplicationCable::Channel
  def listen(data)
    stream_for current_user
    LoadRidesWorker.perform_async(
      current_user.id,
      data['page'],
      data['location']
    )
  end

  def unsubscribed
    stop_all_streams
  end
end
