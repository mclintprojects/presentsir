class EnrollmentSerializer < ActiveModel::Serializer
    attributes :id, :student, :course, :created_at

    has_one :student, serializer: StudentSerializer
    has_one :course, serializer: CourseSerializer
end