class CreateTransactionTypes < ActiveRecord::Migration
  def self.up
    create_table :transaction_types do |t|
      t.string :code, :null=>false
      t.string :description, :null=>false
      t.string :sign, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_types
  end
end
