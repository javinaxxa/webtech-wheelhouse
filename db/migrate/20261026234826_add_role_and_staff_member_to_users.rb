class AddRoleAndStaffMemberToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string, null: false, default: "mechanic"
    add_reference :users, :staff_member, foreign_key: true, index: { unique: true }
  end
end
