class AddNotNullConstraintsToProducts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :name, false
    change_column_null :products, :description, false
    change_column_null :products, :price, false
    change_column_null :products, :stock, false
    change_column_null :products, :color, false
    change_column_null :products, :size, false
    change_column_null :products, :category_id, false
  end
end
