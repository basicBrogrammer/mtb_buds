# frozen_string_literal: true

class ChangeRidesLatitudeAndLongitudeToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :rides, :latitude, 'float USING CAST(latitude AS float)'
    change_column :rides, :longitude, 'float USING CAST(longitude AS float)'
  end
end
