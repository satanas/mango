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

ActiveRecord::Schema.define(:version => 20110815145659) do

  create_table "batches", :force => true do |t|
    t.integer  "order_id"
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.integer  "lot_id"
    t.integer  "schedule_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batches", ["ingredient_id"], :name => "fk_batches_ingredient_id"
  add_index "batches", ["lot_id"], :name => "fk_batches_lot_id"
  add_index "batches", ["order_id"], :name => "fk_batches_order_id"
  add_index "batches", ["recipe_id"], :name => "fk_batches_recipe_id"
  add_index "batches", ["schedule_id"], :name => "fk_batches_schedule_id"
  add_index "batches", ["user_id"], :name => "fk_batches_user_id"

  create_table "clients", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "ci_rif",     :null => false
    t.string   "address"
    t.string   "tel1"
    t.string   "tel2"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hoppers", :force => true do |t|
    t.integer  "number",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hoppers_ingredients", :force => true do |t|
    t.integer  "hopper_id"
    t.integer  "ingredient_id"
    t.boolean  "active",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hoppers_ingredients", ["hopper_id"], :name => "fk_hoppers_ingredients_hopper_id"
  add_index "hoppers_ingredients", ["ingredient_id"], :name => "fk_hoppers_ingredients_ingredient_id"

  create_table "ingredients", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "prog_batchs",                          :null => false
    t.integer  "real_batchs"
    t.string   "code",                                 :null => false
    t.string   "comment"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed_in_baan", :default => false
  end

  add_index "orders", ["client_id"], :name => "fk_orders_client_id"
  add_index "orders", ["product_id"], :name => "fk_orders_product_id"
  add_index "orders", ["recipe_id"], :name => "fk_orders_recipe_id"
  add_index "orders", ["user_id"], :name => "fk_orders_user_id"

  create_table "products", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
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
    t.string   "start_hour"
    t.string   "end_hour"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "login",                            :null => false
    t.string   "password_hash",                    :null => false
    t.string   "password_salt",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",         :default => false
  end

end
