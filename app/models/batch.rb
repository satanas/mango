class Batch < ActiveRecord::Base
  belongs_to :order
  belongs_to :schedule
  belongs_to :user
  has_many :batch_hopper_lot

  validates_uniqueness_of :order_id, :scope => [:number]
  validates_presence_of :order, :schedule, :user, :start_date, :end_date
  validates_numericality_of :number, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :total, :greater_than_or_equal_to => 0
  validates_associated :order, :schedule, :user
  
  before_validation :validates_total

  def validates_total
    self.total = 0 if self.total.nil?
    return true
  end
end
