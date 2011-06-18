class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :code
      t.string :name, :null => false
      t.string :version, :null => false
      t.float :total, :default => 0
      t.boolean :active, :default => true
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
