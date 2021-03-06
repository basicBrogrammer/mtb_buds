# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    confirmed_at { Time.now }
    sequence :name do |n|
      "#{Faker::Movies::StarWars.character} #{n}"
    end
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password { 'please1234' }
    location { 'Asheville, NC, USA' }

    trait :admin do
      role { 'admin' }
    end

    trait :fort_collins do
      location { 'Fort Collins, CO' }
      # latitude { 40.5853 }
      # longitude { -105.0844 }
    end

    # ~50mi
    trait :boulder do
      location { 'Boulder, CO' }
      # latitude { 40.0150 }
      # longitude { -105.2705 }
    end

    # ~95
    trait :breckenridge do
      location { 'Breckenridge, CO' }
      # latitude { 39.4817 }
      # longitude { -106.0384 }
    end

    # ~ 133
    trait :aspen do
      location { 'Aspen, CO' }
      # latitude { 39.1911 }
      # longitude { -106.8175 }
    end

    # ~ 212
    trait :grand_junction do
      location { 'Grand Junction, CO' }
      # latitude { 39.0639 }
      # longitude { -108.5506 }
    end
  end
end
