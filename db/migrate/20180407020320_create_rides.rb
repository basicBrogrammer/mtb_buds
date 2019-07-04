# frozen_string_literal: true

class CreateRides < ActiveRecord::Migration[5.1]
  def change
    create_table :rides do |t|
      t.string :trail_id, null: false
      t.string :longitude, null: false
      t.string :latitude, null: false
      t.string :location
      t.date :day, null: false
      t.time :time, null: false
      t.string :difficulty
      t.float :stars
      t.references :user, index: true

      t.timestamps
    end
  end
end
