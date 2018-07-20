class AddApprovedIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :attendances, :approved
  end
end
