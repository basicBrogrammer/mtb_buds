# frozen_string_literal: true

module Notifications
  class InfiniteLoadController < ApplicationController
    layout false

    def index
      store_location_for(:user, notifications_path)
      # TODO: test infinite scroll
      @notifications = current_user.notifications.includes(:actor).page(params[:page])
      notification_ids = @notifications.pluck(:id)
      # TODO: move marking notifications to on click
      MarkNotificationsAsReadJob.perform_later(notification_ids)
    end
  end
end
