require 'migration_helper'

class CreateBatches < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :batches do |t|
      t.references :order
      t.references :hopper
      t.references :schedule
      t.references :user
      t.integer :number
      t.float :amount
      t.timestamp :start
      t.timestamp :end
      t.timestamps
    end
    add_foreign_key 'batches', 'order_id', 'orders'
    add_foreign_key 'batches', 'hopper_id', 'hoppers'
    add_foreign_key 'batches', 'schedule_id', 'schedules'
    add_foreign_key 'batches', 'user_id', 'users'
  end

  def self.down
    drop_foreign_key 'batches', 'order_id'
    drop_foreign_key 'batches', 'recipe_id'
    drop_foreign_key 'batches', 'hopper_id'
    drop_foreign_key 'batches', 'schedule_id'
    drop_foreign_key 'batches', 'user_id'
    drop_table :batches
  end
end
