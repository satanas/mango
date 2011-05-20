class CreateIngredientsRecipes < ActiveRecord::Migration
  def self.up
    create_table :ingredients_recipes do |t|
      t.integer :ingredient_id
      t.integer :recipe_id
      t.float :amount
      t.integer :priority
      t.float :percentage
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients_recipes
  end
end
