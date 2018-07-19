class AddApprovalIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :attendances, :approval
  end
end
