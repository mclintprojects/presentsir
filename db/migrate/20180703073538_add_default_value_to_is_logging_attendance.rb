class AddDefaultValueToIsLoggingAttendance < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :is_logging_attendance, :boolean, default: false
  end
end
