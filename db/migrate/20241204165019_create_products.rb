class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock
      t.string :color
      t.string :size
      t.string :category
      t.datetime :entry_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
