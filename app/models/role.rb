class Role < ActiveRecord::Base
  has_many :permission_role
  belongs_to :user
end
