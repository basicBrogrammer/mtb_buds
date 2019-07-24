# frozen_string_literal: true

class LoadRidesWorker
  include Sidekiq::Worker
  sidekiq_options retryable: false

  def perform(user_id, page, location)
    user = User.find(user_id)
    rides = if location.present?
              Ride.active.near(location).page(page)
            else
              Ride.active.page(page)
            end
    RidesChannel.broadcast_to(
      user,
      message: RidesController.render_with_user(
        user,
        partial: 'rides',
        locals: { rides: rides }
      )
    )
  end
end
