class HopperLot < ActiveRecord::Base
  belongs_to :hopper
  belongs_to :lot
  has_many :batch_hopper_lot

  validates_associated :hopper, :lot

  def before_save
    HopperLot.update_all('active = false', "hopper_id = #{self.hopper_id}")
    self.active = true
  end
end
