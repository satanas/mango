class Batch < ActiveRecord::Base
  belongs_to :order
  belongs_to :schedule
  belongs_to :user
  has_many :batch_hopper_lot

  validates_uniqueness_of :order_id, :scope => [:number]
  validates_presence_of :order, :schedule, :user, :start_date, :end_date
  validates_numericality_of :number, :only_integer => true, :greater_than_or_equal_to => 0
  validates_associated :order, :schedule, :user

  before_validation :check_associations

  def check_associations
    if order_id.kind_of?(Integer) && !Order.exists?(order_id)
      errors[:order_id] << "doesn't exist"
    end
    if schedule_id.kind_of?(Integer) && !Schedule.exists?(schedule_id)
      errors[:schedule_id] << "doesn't exist"
    end
    if user_id.kind_of?(Integer) && !User.exists?(user_id)
      errors[:user_id] << "doesn't exist"
    end
  end
end
