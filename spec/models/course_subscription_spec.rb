require 'rails_helper'

RSpec.describe CourseSubscription, type: :model do
  it {should validate_presence_of :course_id}
  it {should validate_presence_of :student_id}

  it {should belong_to :student}
  it {should belong_to :course}
end
