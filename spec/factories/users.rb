FactoryBot.define do
  factory :user do
    first_name Forgery('name').first_name
    last_name Forgery('name').last_name
    sequence(:email) { |n| "test#{n}@gmail.com"}
    password 'password'
    user_type 'teacher'
  end
end
