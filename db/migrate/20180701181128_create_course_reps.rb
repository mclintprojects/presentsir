class CreateCourseReps < ActiveRecord::Migration[5.2]
  def change
    create_table :course_reps do |t|
      t.integer :student_id
      t.integer :course_id

      t.timestamps
    end
  end
end
