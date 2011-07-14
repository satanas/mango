module ActiveRecordExtensions
  def self.included(base)
    base.extend(ClassMethods)
  end

  def eliminate
    begin
      self.destroy
    rescue ActiveRecord::StatementInvalid => ex
      errors.add(:foreign_key, 'no se puede eliminar porque tiene registros asociados')
    rescue Exception => ex
      errors.add(:unknown, ex.message)
    end
  end

  module ClassMethods
  end
end
# include the extension 
ActiveRecord::Base.send(:include, ActiveRecordExtensions)
