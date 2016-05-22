FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :username do |n|
    "user#{n}"
  end
  
  factory :user do
    email
    username
    password               "password"
    password_confirmation  "password"
  end
end
