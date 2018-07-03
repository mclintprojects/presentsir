class AddIndexes1 < ActiveRecord::Migration[5.2]
  def change
    add_index :courses, :is_logging_attendance
    add_index :courses, :teacher_id
    add_index :enrollments, :student_id
    add_index :enrollments, :course_id
  end
end
