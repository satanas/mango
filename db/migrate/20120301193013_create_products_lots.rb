require 'migration_helper'

class CreateProductsLots < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :products_lots do |t|
      t.references :product
      t.string :code, :null=>false
      t.date :date
      t.timestamps
    end
    add_foreign_key 'products_lots', 'product_id', 'products'
    add_foreign_key 'orders', 'product_lot_id', 'products_lots'
  end

  def self.down
    drop_foreign_key 'orders', 'product_lot_id'
    drop_foreign_key 'products_lots', 'product_id'
    drop_table :products_lots
  end
end
