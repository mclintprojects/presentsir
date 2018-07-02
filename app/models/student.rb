class Student < ApplicationRecord
    belongs_to :user
    has_many :attendances
    has_many :enrollments
end
