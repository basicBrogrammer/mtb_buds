# frozen_string_literal: true

class ChangeRidesDayColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :rides, :time, :string
  end
end
