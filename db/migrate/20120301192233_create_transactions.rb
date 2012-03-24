class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.references :transaction_type, :null => false
      t.references :warehouse, :null => false
      t.references :user, :null => false
      t.string :code, :null => false
      t.date :date, :null => false
      t.float :amount, :null => false
      t.string :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
