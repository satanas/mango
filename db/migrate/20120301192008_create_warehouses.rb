class CreateWarehouses < ActiveRecord::Migration
  def self.up
    create_table :warehouses do |t|
      t.references :warehouse_type
      t.integer :content_id, :null=>false
      t.string :code, :null=>false
      t.string :location, :null=>false
      t.float :stock, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :warehouses
  end
end
