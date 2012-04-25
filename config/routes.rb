ActionController::Routing::Routes.draw do |map|

  match 'ingredients/search' => "ingredients#search", :via => :get, :as => 'ingredient_search'
  match 'ingredients/catalog' => "ingredients#catalog", :via => :get, :as => 'ingredient_catalog'
  match 'ingredients/select' => "ingredients#select", :via => :get, :as => 'ingredient_select'
  match 'recipes/import' => "recipes#import", :via => :get, :as => 'recipe_import'
  match 'recipes/upload' => "recipes#upload", :via => :get, :as => 'recipe_upload'
  match 'warehouses/recalculate' => "warehouses#recalculate", :via => :get, :as => 'recalculate_warehouses'
  match 'transactions/reprocess' => "transactions#reprocess", :via => :get, :as => 'reprocess_transactions'
  match 'roles/:id/clone' => "roles#clone", :via => :get, :as => 'clone_role'
  match 'sessions/not_implemented' => "sessions#not_implemented", :via => :get, :as => "not_implemented"
  # Reports
  match 'reports/index' => "reports#index", :via => :get, :as => "reports"
  match 'reports/recipes' => "reports#recipes", :via => :get, :as => "recipes_report"
  match 'reports/daily_production' => "reports#daily_production", :via => :get, :as => "daily_production_report"
  match 'reports/order_details' => "reports#order_details", :via => :get, :as => "order_details_report"
  match 'reports/batch_details' => "reports#batch_details", :via => :get, :as => "batch_details_report"
  match 'reports/order_duration' => "reports#order_duration", :via => :get, :as => "order_duration_report"
  match 'reports/consumption_per_recipe' => "reports#consumption_per_recipe", :via => :get, :as => "consumption_per_recipe_report"
  match 'reports/consumption_per_ingredients' => "reports#consumption_per_ingredients", :via => :get, :as => "consumption_per_ingredients_report"
  match 'reports/consumption_per_client' => "reports#consumption_per_client", :via => :get, :as => "consumption_per_client_report"
  match 'reports/adjusments' => "reports#adjusments", :via => :get, :as => "adjusments_report"
  match 'reports/lots_incomes' => "reports#lots_incomes", :via => :get, :as => "lots_incomes_report"
  match 'reports/ingredients_stock' => "reports#ingredients_stock", :via => :get, :as => "ingredients_stock_report"
  match 'reports/product_lots_dispatches' => "reports#product_lots_dispatches", :via => :get, :as => "product_lots_dispatches_report"
  match 'batches/:batch_id/batches_hopper_lot' => "batches_hopper_lot#create", :via => :post, :as => "batches_hopper_lot"
  match 'batches/:batch_id/batches_hopper_lot/:id' => "batches_hopper_lot#destroy", :via => :delete, :as => "batch_hopper_lot"
  resources :sessions, :users, :ingredients, :clients, :hoppers, :products, :orders, :lots, :schedules, :batches,
    :transaction_types, :product_lots, :warehouses, :permissions
  resources :transactions, :except=>:edit

  resources :recipes do
    resources :ingredients_recipes
  end

  resources :roles do
    resources :permissions_roles
  end

  root :to => "sessions#index"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
