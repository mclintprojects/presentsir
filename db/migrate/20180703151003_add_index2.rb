class AddIndex2 < ActiveRecord::Migration[5.2]
  def change
    add_index :enrollments, :created_at
  end
end
