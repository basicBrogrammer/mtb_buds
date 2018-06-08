FactoryBot.define do
  factory :notification do
    actor { create(:user) }
    user { create(:user) }
    read_at nil
    trait :comment_target do 
      target { create(:comment, user: actor) }
    end
    trait :participation_target do 
      target { create(:participation, user: actor) }
    end
  end
end
