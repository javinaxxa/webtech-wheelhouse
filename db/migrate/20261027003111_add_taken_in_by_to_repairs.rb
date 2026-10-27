class AddTakenInByToRepairs < ActiveRecord::Migration[8.1]
  def change
    # The account that created the repair, read from the session. It allows NULL
    # for the repairs that existed before this column.
    add_reference :repairs, :taken_in_by, foreign_key: { to_table: :users }
  end
end
