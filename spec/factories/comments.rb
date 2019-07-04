# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    ride { create(:ride) }
    user { create(:user) }
    body { Faker::Movies::StarWars.quote }
  end
end
