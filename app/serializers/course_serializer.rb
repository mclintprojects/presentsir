class CourseSerializer < ActiveModel::Serializer
    attributes :id, :name, :identifier, :course_code, :course_reps, :teacher_name, :enrollments

    has_many :course_reps, serializer: CourseRepSerializer

    def enrollments
        object.enrollments.count
    end

    def teacher_name
        "#{object.teacher.user.last_name} #{object.teacher.user.first_name}"
    end
end