class HopperIngredient < ActiveRecord::Base
  belongs_to :hopper
  belongs_to :ingredient

  def before_save
    HopperIngredient.update_all('active = false', "hopper_id = #{self.hopper_id}")
    self.active = true
  end
end
