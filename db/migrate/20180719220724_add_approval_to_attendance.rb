class AddApprovalToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :approved, :boolean, default: :false
  end
end
