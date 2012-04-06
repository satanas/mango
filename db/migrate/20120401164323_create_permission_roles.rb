class CreatePermissionRoles < ActiveRecord::Migration
  def self.up
    create_table :permission_roles do |t|
      t.references :permission
      t.references :role
      t.timestamps
    end
  end

  def self.down
    drop_table :permission_roles
  end
end
