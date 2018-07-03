class EnrollmentSerializer < ActiveModel::Serializer
    attributes :id, :student_name, :student, :course, :created_at

    has_one :student, serializer: StudentSerializer
    has_one :course, serializer: CourseSerializer

    def student_name
        "#{object.student.user.last_name} #{object.student.user.first_name}"
    end
end