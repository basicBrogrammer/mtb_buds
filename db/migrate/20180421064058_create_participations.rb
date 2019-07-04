# frozen_string_literal: true

class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.belongs_to :ride, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
      t.index %i[user_id ride_id], unique: true
    end
  end
end
