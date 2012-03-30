class CreateOrdersNumbers < ActiveRecord::Migration
  def self.up
    create_table :orders_numbers do |t|
      t.string :code, :default=>'0000000001'
      t.timestamps
    end
  end

  def self.down
    drop_table :orders_numbers
  end
end
