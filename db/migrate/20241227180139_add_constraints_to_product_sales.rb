class AddConstraintsToProductSales < ActiveRecord::Migration[8.0]
  def change
    change_column_null :product_sales, :product_id, false
    change_column_null :product_sales, :sail_id, false
    change_column_null :product_sales, :amount_sold, false
    change_column_null :product_sales, :total_amount, false
  end
end
