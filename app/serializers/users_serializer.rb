class UsersSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :user_type
end
