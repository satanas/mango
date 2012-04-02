class Permission < ActiveRecord::Base
  has_many :permission_role
end
