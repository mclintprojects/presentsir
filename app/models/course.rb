class Course < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :identifier
    belongs_to :teacher
    has_many :attendances, dependent: :destroy
    has_many :course_reps, dependent: :destroy
    has_many :enrollments, dependent: :destroy

    validate :teacher_cannot_create_same_course

    def teacher_cannot_create_same_course
        existing_course = Course.find_by(teacher_id: teacher_id, course_code: course_code)
        if(existing_course.present? && existing_course.id != id)
            errors.add(:course_code, 'already exists in another course')
        end
    end
end
