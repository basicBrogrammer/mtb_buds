class AddLatitudeAndLongitudeToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_index :users, [:latitude, :longitude]
    add_index :rides, [:latitude, :longitude]

    User.find_each do |user| 
      puts "Geocoding #{user.email}"
      user.geocode 
      user.save
      sleep 5
    end
  end

  def down 
    remove_index :users, [:latitude, :longitude]
    remove_index :rides, [:latitude, :longitude]
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
  end
end
