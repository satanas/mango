class CreateWarehousesTypes < ActiveRecord::Migration
  def self.up
    create_table :warehouses_types do |t|
      t.string :code, :null=>false
      t.string :description, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :warehouses_types
  end
end
