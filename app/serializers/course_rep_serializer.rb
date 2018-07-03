class CourseRepSerializer < ActiveModel::Serializer
    attributes :id, :student

    has_one :student, serializer: StudentSerializer
end