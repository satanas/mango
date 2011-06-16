class Hopper < ActiveRecord::Base
  has_many :hopper_ingredient

  validates_presence_of :number
  validates_numericality_of :number, :only_integer => true, :greater_than_or_equal_to => 0

  def self.find_active
    actives = {}
    hoppers = Hopper.find :all, :order => 'number ASC'
    hoppers.each do |hop|
      ingredients = HopperIngredient.find :first, :conditions => ['hopper_id = ? and active = ?', hop.id, true]
      actives[hop.number] = {
        :ingredient => ingredients,
        :hopper_id => hop.id
      }
    end
    return actives
  end

  def deactivate_all_ingredients
    self.hopper_ingredient.each do |i|
      i.active = false
      i.save
    end
  end
end
