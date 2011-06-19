class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :login, :null => false
      t.string :password_hash, :null => false
      t.string :password_salt, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
