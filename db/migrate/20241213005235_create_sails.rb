class CreateSails < ActiveRecord::Migration[8.0]
  def change
    create_table :sails do |t|
      t.datetime :completed_at, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.references :user, null: false, foreign_key: true
      t.string :client_dni, null: false

      t.timestamps
    end
  end
end
