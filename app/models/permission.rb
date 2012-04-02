class Permission < ActiveRecord::Base
  has_many :permission_role

  MODULES = ['batches', 'orders', 'recipes', 'hoppers', 'transactions', 'warehouses', 'lots', 'product_lots',
    'ingredients', 'products', 'clients', 'transaction_types', 'schedules', 'users', 'reports', 'configuration']

  def self.get_modules
    return MODULES
  end
end
