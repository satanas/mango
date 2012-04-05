class Permission < ActiveRecord::Base
  has_many :permission_role

  MODULES = ['batches', 'orders', 'recipes', 'hoppers', 'transactions', 'warehouses', 'lots', 'product_lots',
    'ingredients', 'products', 'clients', 'transaction_types', 'schedules', 'users', 'roles', 'permissions',
    'reports', 'configuration']
  # Permission actions
  ACTIONS = ['consult', 'modify', 'delete']
  MODES = ['global', 'module']

  # Rails actions
  CONSULT = ['index', 'show']
  MODIFY = ['new', 'edit', 'create', 'update']
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
end
