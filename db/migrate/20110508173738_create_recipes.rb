class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :code
      t.string :name
      t.string :version
      t.float :total
      t.boolean :active, :default => true
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
