class CreateHoppers < ActiveRecord::Migration
  def self.up
    create_table :hoppers do |t|
      t.integer :number, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :hoppers
  end
end
