class AddForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :bikes, :customers
    add_foreign_key :repairs, :bikes
    add_foreign_key :repairs, :staff_members, column: :received_by_id
    add_foreign_key :repairs, :staff_members, column: :assigned_mechanic_id
    add_foreign_key :repair_line_items, :repairs
    add_foreign_key :repair_line_items, :service_types

    add_index :repairs, :received_by_id
    add_index :repairs, :assigned_mechanic_id
  end
end