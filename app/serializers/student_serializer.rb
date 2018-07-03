class StudentSerializer < ActiveModel::Serializer
    attributes :id, :user_id, :name, :email

    def name
        "#{object.user.last_name} #{object.user.first_name}"
    end

    def email
        object.user.email
    end
end