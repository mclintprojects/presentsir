require 'rails_helper'

RSpec.describe User, type: :model do
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :last_name}
  it {should validate_presence_of :email}
  it {should validate_uniqueness_of :email}
  it {should validate_presence_of :password}
  it {should validate_length_of(:password).is_at_least(8).on(:create)}
  it {should have_secure_password}
end
