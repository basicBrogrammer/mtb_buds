# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :user, optional: false
end
