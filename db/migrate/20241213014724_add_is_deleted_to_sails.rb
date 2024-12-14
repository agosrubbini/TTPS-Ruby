class AddIsDeletedToSails < ActiveRecord::Migration[8.0]
  def change
    add_column :sails, :is_deleted, :boolean, default: false
  end
end