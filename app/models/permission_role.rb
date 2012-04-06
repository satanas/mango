class PermissionRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission

  def self.find_with_permissions(role_id, controller, mode)
    return find :all, :conditions => {:role_id => role_id, :permissions => {:module => controller, :mode=>mode}}, :include => [:permission]
  end
end
