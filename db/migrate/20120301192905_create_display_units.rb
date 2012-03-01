class CreateDisplayUnits < ActiveRecord::Migration
  def self.up
    create_table :display_units do |t|
      t.references :base_unit
      t.string :code, :null=>false
      t.float :rate, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :display_units
  end
end
