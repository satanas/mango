class AddCodeToClient < ActiveRecord::Migration
  def self.up
    add_column :clients, :code, :string, :null => false
  end

  def self.down
    remove_column :clients, :code
  end
end
