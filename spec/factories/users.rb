FactoryBot.define do
  factory :user do
    first_name Forgery('name').first_name
    last_name Forgery('name').last_name
    email Forgery('internet').email_address
    password Forgery('basic').password

    factory :teacher do
      user_type "teacher"
    end

    factory :student do
      user_type "student"
    end
  end
end
