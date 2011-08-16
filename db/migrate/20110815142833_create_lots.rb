require 'migration_helper'

class CreateLots < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :lots do |t|
      t.string :code
      t.float :amount, :default => 0
      t.date :date
      t.references :ingredient
      t.timestamps
    end
    add_foreign_key 'lots', 'ingredient_id', 'ingredients'
  end

  def self.down
    drop_foreign_key 'lots', 'ingredient_id'
    drop_table :lots
  end
end
