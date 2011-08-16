ActionController::Routing::Routes.draw do |map|

  root :to => "sessions#index"

  #map.session_error 'session/error', :controller => 'session', :action => 'error'
  map.ingredient_search 'ingredients/search', :controller => "ingredients", :action => "search"
  map.ingredient_catalog 'ingredients/catalog', :controller => "ingredients", :action => "catalog"
  map.ingredient_select 'ingredients/select', :controller => "ingredients", :action => "select"
  map.recipe_import 'recipes/import', :controller => "recipes", :action => "import"
  map.recipe_upload 'recipes/upload', :controller => "recipes", :action => "upload"
  map.reports 'reports/index', :controller => "reports", :action => "index"
  map.recipes_report 'reports/recipes', :controller => "reports", :action => "recipes"
  map.not_implemented 'sessions/not_implemented', :controller => "sessions", :action => "not_implemented"
  map.resources :sessions, :users, :ingredients, :clients, :hoppers, :products, :orders, :lots, :schedules, :batches
  map.resources :recipes do |recipes|
    recipes.resources :ingredients_recipes
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
