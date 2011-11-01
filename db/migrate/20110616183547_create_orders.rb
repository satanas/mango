require 'migration_helper'

class CreateOrders < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :orders do |t|
      t.references :recipe
      t.references :client
      t.references :user
      t.references :product
      t.integer :prog_batches, :null => false
      t.integer :real_batches
      t.string :code, :null => false
      t.string :comment
      t.boolean :completed, :default => false
      t.boolean :processed_in_baan, :default => false
      t.timestamps :register_date
      t.timestamps :start_date
      t.timestamps :end_date
      t.timestamps
    end
    add_foreign_key 'orders', 'recipe_id', 'recipes'
    add_foreign_key 'orders', 'client_id', 'clients'
    add_foreign_key 'orders', 'user_id', 'users'
    add_foreign_key 'orders', 'product_id', 'products'
  end

  def self.down
    drop_foreign_key 'orders', 'product_id'
    drop_foreign_key 'orders', 'user_id'
    drop_foreign_key 'orders', 'client_id'
    drop_foreign_key 'orders', 'recipe_id'
    drop_table :orders
  end
end
