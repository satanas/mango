class CreateIngredientsRecipes < ActiveRecord::Migration
  def self.up
    create_table :ingredients_recipes do |t|
      t.integer :ingredient_id, :null => false
      t.integer :recipe_id, :null => false
      t.float :amount, :null => false
      t.integer :priority, :null => false
      t.float :percentage, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients_recipes
  end
end
