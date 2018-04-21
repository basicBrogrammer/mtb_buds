FactoryBot.define do
  factory :participation do
    user { create(:user) }
    ride { create(:ride) }

    trait :pending do
      status 'pending'
    end

    trait :accepted do
      status 'accepted'
    end

    trait :rejected do
      status 'rejected'
    end
  end
end
