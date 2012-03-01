class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.references :transaction_type
      t.references :warehouse
      t.references :user
      t.datetime :date
      t.float :amount
      t.string :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
