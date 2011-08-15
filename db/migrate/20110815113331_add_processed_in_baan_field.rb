class AddProcessedInBaanField < ActiveRecord::Migration
  def self.up
    add_column :orders, :processed_in_baan, :boolean, :default=>false
  end

  def self.down
    remove_column :orders, :processed_in_baa
  end
end
