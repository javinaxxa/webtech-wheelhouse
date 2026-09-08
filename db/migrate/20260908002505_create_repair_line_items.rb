class CreateRepairLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :repair_line_items do |t|
      t.references :repair, null: false
      t.references :service_type, null: false
      t.decimal :price_charged, precision: 10, scale: 2, null: false
      t.string :discount_note

      t.timestamps
    end
  end
end