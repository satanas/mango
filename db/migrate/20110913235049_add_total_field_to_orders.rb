class AddTotalFieldToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :total, :float
  end

  def self.down
    remove_column :orders, :total
  end
end
