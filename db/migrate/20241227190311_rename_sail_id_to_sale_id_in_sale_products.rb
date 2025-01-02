class RenameSailIdToSaleIdInSaleProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :product_sales, :sail_id, :sale_id
  end
end
