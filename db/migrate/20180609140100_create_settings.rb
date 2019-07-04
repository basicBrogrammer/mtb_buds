# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.references :user, foreign_key: true, null: false
      t.boolean :comment_notifications, default: true, null: false
      t.boolean :participation_notifications, default: true, null: false

      t.timestamps
    end
  end
end
