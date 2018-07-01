class Attendance < ApplicationRecord
    validates_presence_of :course_id
    validates_presence_of :student_id
    belongs_to :course
    belongs_to :student
end
