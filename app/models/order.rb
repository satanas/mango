class Order < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :client
  belongs_to :user
  belongs_to :product
  has_many :batch

  validates_presence_of :recipe_id, :user_id
  validates_numericality_of :prog_batches, :real_batches, :only_integer => 0, :greater_than_or_equal_to => 0
  validates_associated :recipe, :client, :user

  before_validation :validates_real_batchs
  before_save :create_code

  def validates_real_batchs
    self.real_batches = 0 if self.real_batches.nil?
    return true
  end

  def calculate_start_date
    Batch.where(:order_id=>self.id).minimum('created_at').strftime("%d/%m/%Y %H:%M:%S")
  end

  def calculate_end_date
    last_batch = Batch.find(:first, :conditions => ["number = ? and order_id = ?", Batch.where(:order_id=>self.id).maximum('number'), self.id])
    end_date = BatchHopperLot.where(:batch_id=>last_batch.id).maximum('created_at')
    return end_date.strftime("%d/%m/%Y %H:%M:%S")
  end

  def calculate_duration
    start_date = Batch.where(:order_id=>self.id).minimum('created_at')
    last_batch = Batch.find(:first, :conditions => ["number = ? and order_id = ?", Batch.where(:order_id=>self.id).maximum('number'), self.id])
    end_date = BatchHopperLot.where(:batch_id=>last_batch.id).maximum('created_at')

    return {
      'start_date' => start_date.strftime("%d/%m/%Y %H:%M:%S"),
      'end_date' => end_date.strftime("%d/%m/%Y %H:%M:%S"),
      'duration' => (end_date.to_i - start_date.to_i) / 60.0
    }
  end

  def get_real_batches
    Batch.where(:order_id => self.id).count #We are not using this field => @order.real_batches.to_s
  end

  def create_code
    order = OrderNumber.first
    self.code = order.code.succ
    order.code = self.code
    order.save
  end

end
