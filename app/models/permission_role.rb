class PermissionRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission

  def self.find_with_permissions(role_id, controller, mode)
    return find :all, :conditions => {:role_id => role_id, :permissions => {:module => controller, :mode=>mode}}, :include => [:permission]
  end

  def self.generate_god_role
    admin_role = Role.find(1)
    admin_role.permission_role.clear
    Permission.all.each do |perm|
      perm_role = PermissionRole.new
      perm_role.permission_id = perm.id
      perm_role.role_id = admin_role.id
      admin_role.permission_role << perm_role
    end
    admin_role.save
  end

  def self.generate_scada_role
    scada_role = Role.find(2)
    scada_role.permission_role.clear
    permissions = Permission.find :all, :conditions=>["module = 'batches'"]
    permissions.each do |perm|
      perm_role = PermissionRole.new
      perm_role.permission_id = perm.id
      perm_role.role_id = scada_role.id
      scada_role.permission_role << perm_role
    end
    scada_role.save
  end
end
