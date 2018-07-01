class AddCourseIdToAttendance < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :class_id
    add_column :attendances, :course_id, :integer
  end
end
