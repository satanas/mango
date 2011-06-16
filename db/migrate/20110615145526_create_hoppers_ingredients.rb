class CreateHoppersIngredients < ActiveRecord::Migration
  def self.up
    create_table :hoppers_ingredients do |t|
      t.integer :hopper_id, :null => false
      t.integer :ingredient_id, :null => false
      t.boolean :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :hoppers_ingredients
  end
end
