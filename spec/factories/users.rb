FactoryBot.define do
  factory :user do
    confirmed_at Time.now
    name "Test User"
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "please1234"

    trait :admin do
      role 'admin'
    end

  end
end
