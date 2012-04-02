class Role < ActiveRecord::Base
  has_many :permission_role
  has_many :role_user
end
