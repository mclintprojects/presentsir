FactoryBot.define do
  factory :course do
    name Forgery('name').full_name
    identifier Forgery('basic').password
    course_code 'TEST-CODE'
    teacher

    factory :logging_course do
      is_logging_attendance true
    end
  end
end
