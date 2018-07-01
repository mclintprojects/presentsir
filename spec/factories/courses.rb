FactoryBot.define do
  factory :course do
    name Forgery('name').full_name
    identifier Forgery('basic').password
  end
end
