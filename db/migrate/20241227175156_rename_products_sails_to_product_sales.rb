class RenameProductsSailsToProductSales < ActiveRecord::Migration[8.0]
  def change
    rename_table :products_sails, :product_sales
  end
end
