class CreateBasesUnits < ActiveRecord::Migration
  def self.up
    create_table :bases_units do |t|
      t.string :code, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :bases_units
  end
end
