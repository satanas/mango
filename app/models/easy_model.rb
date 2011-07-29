class EasyModel
  def self.recipes
    data = {}
    data['title'] = 'Reporte de recetas'
    data['table1'] = []
    @recipes = Recipe.find :all, :include => {:ingredient_recipe => :ingredient}
    @recipes.each do |r|
      receta = "Receta: #{r.code} - #{r.name} Version: #{r.version}"
      r.ingredient_recipe.each do |ing|
        data['table1'] << {
          'recipe' => receta,
          'code' => ing.ingredient.code,
          'name' => ing.ingredient.name,
          'amount' => ing.amount.to_s,
          'priority' => ing.priority.to_s,
          'percentage' => ing.percentage.to_s
        }
      end
    end
    data['total'] = "Recetas procesadas: #{Recipe.count}"
    return data
  end
end
