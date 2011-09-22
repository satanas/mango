require 'migration_helper'

class CreateBatchHoppersLots < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :batch_hoppers_lots do |t|
      t.references :batch
      t.references :hopper_lot
      t.float :amount, :null => false
      t.timestamps
    end
    add_foreign_key 'batch_hoppers_lots', 'batch_id', 'batches'
    add_foreign_key 'batch_hoppers_lots', 'hopper_lot_id', 'hoppers_lots'
  end

  def self.down
    drop_foreign_key 'batch_hoppers_lots', 'batch_id'
    drop_foreign_key 'batch_hoppers_lots', 'hopper_lot_id'
    drop_table :batch_hoppers_lots
  end
end
