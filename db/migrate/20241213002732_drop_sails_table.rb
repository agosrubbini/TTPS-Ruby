class DropSailsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :sails
  end

  def down
    create_table :sails do |t|
      t.datetime :completed_at
      t.decimal :total_amount, precision: 10, scale: 2
      t.integer :employee_id
      t.string :client_dni
      t.timestamps
    end
  end
end
