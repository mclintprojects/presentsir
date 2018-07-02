FactoryBot.define do
  factory :course do
    name Forgery('name').full_name
    identifier Forgery('basic').password
    course_code 'TEST-CODE'
    teacher
  end
end
