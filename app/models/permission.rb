class Permission < ActiveRecord::Base
  has_many :permission_role

  after_save :associate_role
  after_destroy :deassociate_role

  MODULES = ['batches', 'orders', 'recipes', 'hoppers', 'transactions', 'warehouses', 'lots', 'product_lots',
    'ingredients', 'products', 'clients', 'transaction_types', 'schedules', 'users', 'roles', 'permissions',
    'reports', 'configuration']
  # Permission actions
  ACTIONS = ['consult', 'modify', 'delete']
  MODES = ['global', 'module']

  # Rails actions
  CONSULT = ['index', 'show']
  MODIFY = ['new', 'edit', 'create', 'update', 'clone']
  DELETE = ['destroy']

  def self.get_modules
    MODULES
  end

  def self.get_actions
    ACTIONS
  end

  def self.get_modes
    MODES
  end

  def self.is_consult?(action)
    CONSULT.include?(action)
  end

  def self.is_modify?(action)
    MODIFY.include?(action)
  end

  def self.is_delete?(action)
    DELETE.include?(action)
  end

  def self.is_recalculate?(action)
    return action == 'recalculate'
  end

  def self.is_import?(action)
    return action == 'import'
  end

  def self.get_all
    find :all, :order => 'module ASC'
  end

  private

  def associate_role
    pr = PermissionRole.create({:permission_id=>self.id, :role_id=>1})
  end

  def deassociate_role
    PermissionRole.delete_all :permission_id=>self.id
  end
end
