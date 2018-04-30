FactoryBot.define do
  factory :ride do
    day { Date.today + (0..10).to_a.sample.days }
    time { Time.zone.now + (0..200).to_a.sample.minutes }
    trail_id { ["7019014", "365066", "2421789", "342104"].sample }
    user { create(:user) }
  end
end
