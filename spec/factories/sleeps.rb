FactoryBot.define do
  factory :sleep do
    clocked_in_at { 8.hours.ago }
    trait :in_progress do
      clocked_out_at { nil }
    end
  end
end
