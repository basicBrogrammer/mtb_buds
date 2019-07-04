# frozen_string_literal: true

class AddRideNotificationsToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :ride_notifications, :boolean, default: true
  end
end
