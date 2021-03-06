class Client < ActiveRecord::Base
  has_many :order

  validates_uniqueness_of :ci_rif, :code
  validates_presence_of :name, :code, :ci_rif, :address, :tel1
  validates_length_of :ci_rif, :within => 3..10
  validates_length_of :name, :within => 3..40
end
