FactoryBot.define do
  factory :ride do
    day { Date.today }
    time { Time.zone.now }
    trail_id { ['7019014', '365066'].sample }
    user { create(:user) }
  end
end
