class Course < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :identifier
end
