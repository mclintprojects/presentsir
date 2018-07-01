class CourseSerializer < ActiveModel::Serializer
    attributes :id, :name, :identifier, :course_reps

    has_many :course_reps, serializer: CourseRepSerializer
end