class Course < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :identifier
    belongs_to :teacher
    has_many :attendance
end
