class Attendance < ApplicationRecord
    validates_presence_of :course_id
    validates_presence_of :student_id
    belongs_to :course
    belongs_to :student

    validate :cannot_attend_class_twice_in_a_day

    def cannot_attend_class_twice_in_a_day
        existing_attendance = Attendance.find_by(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        errors.add(:student, 'has already attended class today') if existing_attendance.present?
    end
end
