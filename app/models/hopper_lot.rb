class HopperLot < ActiveRecord::Base
  belongs_to :hopper
  belongs_to :lot

  def before_save
    HopperLot.update_all('active = false', "hopper_id = #{self.hopper_id}")
    self.active = true
  end
end
