class CreateProductsLots < ActiveRecord::Migration
  def self.up
    create_table :products_lots do |t|
      t.references :order
      t.string :number, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :products_lots
  end
end
