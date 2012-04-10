class AddProcessedInStockToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :processed_in_stock, :integer, :default=>0
  end

  def self.down
    remove_column :transactions, :processed_in_stock
  end
end
