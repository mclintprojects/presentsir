class CourseSerializer < ActiveModel::Serializer
    attributes :id, :name, :identifier, :course_code, :course_reps, :enrollments

    has_many :course_reps, serializer: CourseRepSerializer

    def enrollments
        object.course_subscriptions.count
    end
end