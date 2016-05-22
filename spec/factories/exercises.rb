FactoryGirl.define do
  factory :sit_up do
    user
    type "SitUp"
    duration 120
    repetitions 30
  end

  factory :push_up do
    user
    type "PushUp"
    duration 120
    repetitions 30
  end
end
