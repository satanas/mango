class Ingredient < ActiveRecord::Base
  has_many :ingredient_recipe
  has_many :hopper_ingredient

  validates_uniqueness_of :code
  validates_presence_of :name, :code
  validates_length_of :code, :name, :within => 3..40

  def eliminate
    begin
      self.destroy
    rescue ActiveRecord::StatementInvalid => ex
      errors.add(:foreign_key, 'No se puede eliminar porque tiene registros asociados')
    rescue Exception => ex
      errors.add(:unknown, ex.message)
    end
  end
end
