class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.integer :class_id
      t.integer :student_id

      t.timestamps
    end
  end
end
