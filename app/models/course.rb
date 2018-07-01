class Course < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :identifier
    belongs_to :teacher
    has_many :attendances
    has_many :course_reps
    has_many :course_subscriptions
end
