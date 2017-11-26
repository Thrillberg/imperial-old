FactoryBot.define do
  factory :user do
    email
    username
    password 'password'
  end

  sequence :email do |n|
    "email#{n}@test.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  trait :creator do
    
  end
end
