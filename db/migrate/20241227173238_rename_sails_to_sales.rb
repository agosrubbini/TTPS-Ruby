class RenameSailsToSales < ActiveRecord::Migration[8.0]
  def change
    rename_table :sails, :sales
  end
end
