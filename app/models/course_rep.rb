class CourseRep < ApplicationRecord
    validates_presence_of :student_id
    validates_presence_of :course_id

    belongs_to :student
    belongs_to :course
end
