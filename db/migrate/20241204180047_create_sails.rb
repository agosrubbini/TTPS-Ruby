class CreateSails < ActiveRecord::Migration[8.0]
  def change
    create_table :sails do |t|
      t.datetime :completed_at
      t.decimal :total_amount
      t.references :employee, null: false, foreign_key: true
      t.integer :client_dni

      t.timestamps
    end
  end
end
