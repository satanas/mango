class CreateIngredientsRecipes < ActiveRecord::Migration
  def self.up
    create_table :ingredients_recipes do |t|
      t.integer :ingredient_id
      t.integer :recipe_id
      t.decimal :dosis
      t.integer :prioridad
      t.decimal :percentage
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients_recipes
  end
end
