FactoryBot.define do
  factory :user do
    confirmed_at Time.now
    sequence :name do |n|
       "#{Faker::StarWars.character} #{n}"
    end
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "please1234"

    trait :admin do
      role 'admin'
    end
  end
end
