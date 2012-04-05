class Permission < ActiveRecord::Base
  has_many :permission_role

  MODULES = ['batches', 'orders', 'recipes', 'hoppers', 'transactions', 'warehouses', 'lots', 'product_lots',
    'ingredients', 'products', 'clients', 'transaction_types', 'schedules', 'users', 'roles', 'permissions',
    'reports', 'configuration']

  ACTIONS = ['consult', 'modify', 'delete']

  MODES = ['global', 'module']

  def self.get_modules
    return MODULES
  end

  def self.get_actions
    return ACTIONS
  end

  def self.get_modes
    return MODES
  end
end
