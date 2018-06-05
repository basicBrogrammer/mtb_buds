# frozen_string_literal: true

module Notifications
  class InfiniteLoadController < ApplicationController
    layout false

    def index
      # @notifications = current_user.notifications
    end
  end
end
