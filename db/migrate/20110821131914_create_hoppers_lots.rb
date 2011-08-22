require 'migration_helper'

class CreateHoppersLots < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :hoppers_lots do |t|
      t.references :hopper
      t.references :lot
      t.boolean :active, :default=>false
      t.timestamps
    end
    add_foreign_key 'hoppers_lots', 'lot_id', 'lots'
    add_foreign_key 'hoppers_lots', 'hopper_id', 'hoppers'
  end

  def self.down
    drop_foreign_key 'hoppers_lots', 'lot_id'
    drop_foreign_key 'hoppers_lots', 'hopper_id'
    drop_table :hoppers_lots
  end
end
