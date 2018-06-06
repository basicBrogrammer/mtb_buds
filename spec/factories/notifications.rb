FactoryBot.define do
  factory :notification do
    actor { create(:user) }
    user { create(:user) }
    trait :comment_target do 
      target { create(:comment, user: actor) }
    end
  end
end
