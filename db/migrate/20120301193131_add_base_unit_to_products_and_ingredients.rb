class AddBaseUnitToProductsAndIngredients < ActiveRecord::Migration
  def self.up
    add_column :products, :base_unit_id, :integer, :references=>'bases_units'
    add_column :ingredients, :base_unit_id, :integer, :references=>'bases_units'
    Product.find_each do |p|
      p.base_unit_id = 2
    end
    Ingredient.find_each do |i|
      i.base_unit_id = 1
    end
  end

  def self.down
    remove_column :products, :base_unit_id
    remove_column :ingredients, :base_unit_id
  end
end
