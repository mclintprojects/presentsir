class CourseRep < ApplicationRecord
    validates_presence_of :student_id
    validates_presence_of :course_id
    validate :can_only_be_assigned_to_class_one

    belongs_to :student
    belongs_to :course

    def can_only_be_assigned_to_class_one
        if(CourseRep.find_by(student_id: student_id, course_id: course_id).present?)
            errors.add(:student, 'is already assigned to course')
        end
    end
end
