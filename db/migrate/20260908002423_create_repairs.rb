class CreateRepairs < ActiveRecord::Migration[8.1]
  def change
    create_table :repairs do |t|
      t.references :bike, null: false
      t.bigint :received_by_id, null: false
      t.bigint :assigned_mechanic_id
      t.string :status, null: false, default: "dropped_off"
      t.date :promised_on, null: false
      t.datetime :dropped_off_at, null: false
      t.datetime :completed_at
      t.datetime :picked_up_at
      t.boolean :customer_approved

      t.timestamps
    end
  end
end