# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    user { nil }
    comment_notifications { false }
    participation_notifications { false }
  end
end
