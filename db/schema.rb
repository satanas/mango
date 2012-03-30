# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120330020014) do

  create_table "bases_units", :force => true do |t|
    t.string   "code",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_hoppers_lots", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "hopper_lot_id"
    t.float    "amount",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_hoppers_lots", ["batch_id"], :name => "fk_batch_hoppers_lots_batch_id"
  add_index "batch_hoppers_lots", ["hopper_lot_id"], :name => "fk_batch_hoppers_lots_hopper_lot_id"

  create_table "batches", :force => true do |t|
    t.integer  "order_id"
    t.integer  "schedule_id"
    t.integer  "user_id"
    t.integer  "number"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batches", ["order_id"], :name => "fk_batches_order_id"
  add_index "batches", ["schedule_id"], :name => "fk_batches_schedule_id"
  add_index "batches", ["user_id"], :name => "fk_batches_user_id"

  create_table "clients", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.string   "ci_rif",     :null => false
    t.string   "address"
    t.string   "tel1"
    t.string   "tel2"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "display_units", :force => true do |t|
    t.integer  "base_unit_id"
    t.string   "code",         :null => false
    t.float    "rate",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hoppers", :force => true do |t|
    t.integer  "number",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hoppers_lots", :force => true do |t|
    t.integer  "hopper_id"
    t.integer  "lot_id"
    t.boolean  "active",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hoppers_lots", ["hopper_id"], :name => "fk_hoppers_lots_hopper_id"
  add_index "hoppers_lots", ["lot_id"], :name => "fk_hoppers_lots_lot_id"

  create_table "ingredients", :force => true do |t|
    t.string   "code",         :null => false
    t.string   "name",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "base_unit_id"
  end

  create_table "ingredients_recipes", :force => true do |t|
    t.integer  "ingredient_id"
    t.integer  "recipe_id"
    t.float    "amount",        :null => false
    t.integer  "priority",      :null => false
    t.float    "percentage",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredients_recipes", ["ingredient_id"], :name => "fk_ingredients_recipes_ingredient_id"
  add_index "ingredients_recipes", ["recipe_id"], :name => "fk_ingredients_recipes_recipe_id"

  create_table "lots", :force => true do |t|
    t.string   "code"
    t.date     "date"
    t.string   "location"
    t.integer  "ingredient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lots", ["ingredient_id"], :name => "fk_lots_ingredient_id"

  create_table "orders", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "prog_batches",                         :null => false
    t.integer  "real_batches"
    t.string   "code",                                 :null => false
    t.string   "comment"
    t.boolean  "completed",         :default => false
    t.boolean  "processed_in_baan", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["client_id"], :name => "fk_orders_client_id"
  add_index "orders", ["product_id"], :name => "fk_orders_product_id"
  add_index "orders", ["recipe_id"], :name => "fk_orders_recipe_id"
  add_index "orders", ["user_id"], :name => "fk_orders_user_id"

  create_table "orders_numbers", :force => true do |t|
    t.string   "code",       :default => "0000000001"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "code",         :null => false
    t.string   "name",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "base_unit_id"
  end

  create_table "products_lots", :force => true do |t|
    t.integer  "order_id"
    t.string   "code",       :null => false
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", :force => true do |t|
    t.string   "code"
    t.string   "name",                         :null => false
    t.string   "version"
    t.float    "total",      :default => 0.0
    t.boolean  "active",     :default => true
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.time     "start_hour"
    t.time     "end_hour"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_types", :force => true do |t|
    t.string   "code",        :null => false
    t.string   "description", :null => false
    t.string   "sign",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "transaction_type_id", :null => false
    t.integer  "warehouse_id",        :null => false
    t.integer  "user_id",             :null => false
    t.string   "code",                :null => false
    t.date     "date",                :null => false
    t.float    "amount",              :null => false
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_number"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "login",                            :null => false
    t.string   "password_hash",                    :null => false
    t.string   "password_salt",                    :null => false
    t.boolean  "admin",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouses", :force => true do |t|
    t.integer  "warehouse_type_id"
    t.integer  "content_id",                         :null => false
    t.string   "code",                               :null => false
    t.string   "location",                           :null => false
    t.float    "stock",             :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouses_types", :force => true do |t|
    t.string   "code",        :null => false
    t.string   "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
