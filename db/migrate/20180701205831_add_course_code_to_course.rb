class AddCourseCodeToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :course_code, :string
  end
end
