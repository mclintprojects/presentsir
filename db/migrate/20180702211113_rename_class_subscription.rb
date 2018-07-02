class RenameClassSubscription < ActiveRecord::Migration[5.2]
  def change
    rename_table :course_subscriptions, :enrollments
    add_column :courses, :is_logging_attendance, :boolean
  end
end
