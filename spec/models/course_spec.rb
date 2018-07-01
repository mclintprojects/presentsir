require 'rails_helper'

RSpec.describe Course, type: :model do
  it {should validate_presence_of :name}
  it {should validate_presence_of :identifier}
  it {should belong_to :teacher}
  it {should have_many :attendances}
  it {should have_many :course_reps}
end
