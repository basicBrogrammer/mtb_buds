FactoryBot.define do
  factory :comment do
    ride { create(:ride) }
    user { create(:user) }
    body { Faker::StarWars.quote }
  end
end
