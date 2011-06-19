require 'migration_helper'

class CreateHoppersIngredients < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :hoppers_ingredients do |t|
      t.references :hopper
      t.references :ingredient
      t.boolean :active, :default => false
      t.timestamps
    end
    add_foreign_key 'hoppers_ingredients', 'ingredient_id', 'ingredients'
    add_foreign_key 'hoppers_ingredients', 'hopper_id', 'hoppers'
  end

  def self.down
    drop_foreign_key 'hoppers_ingredients', 'ingredient_id'
    drop_foreign_key 'hoppers_ingredients', 'hopper_id'
    drop_table :hoppers_ingredients
  end
end

