require 'migration_helper'

class CreateIngredientsRecipes < ActiveRecord::Migration
extend MigrationHelper
  def self.up
    create_table :ingredients_recipes do |t|
      t.references :ingredient
      t.references :recipe
      t.float :amount, :null => false
      t.integer :priority, :null => false
      t.float :percentage, :null => false
      t.timestamps
    end
    add_foreign_key 'ingredients_recipes', 'ingredient_id', 'ingredients'
    add_foreign_key 'ingredients_recipes', 'recipe_id', 'recipes'
  end

  def self.down
    drop_foreign_key 'ingredients_recipes', 'ingredient_id'
    drop_foreign_key 'ingredients_recipes', 'recipe_id'
    drop_table :ingredients_recipes
  end
end
