class Order < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :client
  belongs_to :user
  belongs_to :product
  has_many :batch

  validates_presence_of :recipe_id, :user_id
  validates_uniqueness_of :code
  validates_numericality_of :prog_batches, :real_batches, :only_integer => 0, :greater_than_or_equal_to => 0
  validates_associated :recipe, :client, :user

  before_validation :validates_real_batchs

  def validates_real_batchs
    self.real_batches = 0 if self.real_batches.nil?
    return true
  end
end
