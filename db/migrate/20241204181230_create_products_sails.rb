class CreateProductsSails < ActiveRecord::Migration[8.0]
  def change
    create_table :products_sails do |t|
      t.integer :product_id
      t.integer :sail_id
      t.integer :amount_sold
      t.decimal :total_amount

      t.timestamps
    end
    # Agregar índices para optimizar las búsquedas
    add_index :products_sails, :product_id
    add_index :products_sails, :sail_id
    add_index :products_sails, [:product_id, :sail_id], unique: true # para evitar duplicados
  end
end
