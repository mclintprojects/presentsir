class CourseSerializer < ActiveModel::Serializer
    attributes :id, :user

    has_one :user, serializer: UsersSerializer
end