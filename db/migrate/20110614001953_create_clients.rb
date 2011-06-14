class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name, :null => false
      t.string :ci_rif, :null => false
      t.string :address
      t.string :tel1
      t.string :tel2
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
