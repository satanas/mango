class Role < ActiveRecord::Base
  has_many :permission_role
  has_one :user

  def self.get_all
    find :all, :order => 'name ASC'
  end
end
