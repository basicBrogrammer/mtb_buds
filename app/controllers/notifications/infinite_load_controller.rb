# frozen_string_literal: true

module Notifications
  class InfiniteLoadController < ApplicationController
    layout false

    def index
      store_location_for(:user, notifications_path)
      # TODO: pagination for infinite load
      @notifications = current_user.notifications.includes(:actor).page(params[:page])
      notification_ids = @notifications.pluck(:id)
      MarkNotificationsAsReadJob.perform_later(notification_ids)
    end
  end
end
