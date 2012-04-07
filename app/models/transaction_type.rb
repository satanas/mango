class TransactionType < ActiveRecord::Base
  has_many :transaction

  validates_uniqueness_of :code
  validates_presence_of :code, :description, :sign

  after_save :create_permission
  after_destroy :destroy_permission

  private

  def create_permission
    p = Permission.create({:name=>"Transaction '#{self.description}'", :module=>'transactions', :action=>self.code, :mode=>'module'})
  end

  def destroy_permission
    begin
      p = Permission.find :first, :conditions=>{:module=>'transactions', :action=>self.code, :mode=>'module'}
      p.destroy
    rescue
    end
  end
end
