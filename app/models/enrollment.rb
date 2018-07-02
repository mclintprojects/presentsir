class Enrollment < ApplicationRecord
    validates_presence_of :course_id
    validates_presence_of :student_id
    validate :student_can_only_enroll_once

    belongs_to :student
    belongs_to :course

    def student_can_only_enroll_once
        if(Enrollment.find_by(student_id: student_id, course_id: course_id))
            errors.add(:student, 'can only enroll in course once')
        end
    end
end
