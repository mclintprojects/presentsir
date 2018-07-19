class AddApprovedIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :attendances, :approved
    remove_index :attendances, name: 'index_attendances_on_approval'
  end
end
