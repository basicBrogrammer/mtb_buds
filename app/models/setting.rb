class Setting < ApplicationRecord
  belongs_to :user, required: true
end
