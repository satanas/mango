ActionController::Routing::Routes.draw do |map|

  match 'ingredients/search' => "ingredients#search", :via => :get, :as => 'ingredient_search'
  match 'ingredients/catalog' => "ingredients#catalog", :via => :get, :as => 'ingredient_catalog'
  match 'ingredients/select' => "ingredients#select", :via => :get, :as => 'ingredient_select'
  match 'recipes/import' => "recipes#import", :via => :get, :as => 'recipe_import'
  match 'recipes/upload' => "recipes#upload", :via => :get, :as => 'recipe_upload'
  match 'sessions/not_implemented' => "sessions#not_implemented", :via => :get, :as => "not_implemented"
  # Reports
  match 'reports/index' => "reports#index", :via => :get, :as => "reports"
  match 'reports/recipes' => "reports#recipes", :via => :get, :as => "recipes_report"
  match 'reports/daily_production' => "reports#daily_production", :via => :get, :as => "daily_production_report"
  match 'reports/order_details' => "reports#order_details", :via => :get, :as => "order_details_report"
  match 'reports/batch_details' => "reports#batch_details", :via => :get, :as => "batch_details_report"
  match 'reports/ingredient_variation' => "reports#ingredient_variation", :via => :get, :as => "ingredient_variation_report"
  match 'reports/order_duration' => "reports#order_duration", :via => :get, :as => "order_duration_report"
  match 'batches/:batch_id/batches_hopper_lot' => "batches_hopper_lot#create", :via => :post, :as => "batches_hopper_lot"
  match 'batches/:batch_id/batches_hopper_lot/:id' => "batches_hopper_lot#destroy", :via => :delete, :as => "batch_hopper_lot"
  resources :sessions, :users, :ingredients, :clients, :hoppers, :products, :orders, :lots, :schedules, :batches,
    :transaction_types, :product_lots, :transactions, :warehouses

  resources :recipes do
    resources :ingredients_recipes
  end

  root :to => "sessions#index"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
