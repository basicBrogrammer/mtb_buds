# frozen_string_literal: true

class AddLatitudeAndLongitudeToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_index :users, %i[latitude longitude]
    add_index :rides, %i[latitude longitude]

    User.find_each do |user|
      puts "Geocoding #{user.email}"
      user.geocode
      user.save
      sleep 5
    end
  end

  def down
    remove_index :users, %i[latitude longitude]
    remove_index :rides, %i[latitude longitude]
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
  end
end
