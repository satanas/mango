class Order < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :client
  belongs_to :user
  belongs_to :product_lot
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
    unless end_date.nil?
      return end_date.strftime("%d/%m/%Y %H:%M:%S")
    else
      return "??/??/???? ??:??:??"
    end
  end

  def calculate_duration
    start_date = Batch.where(:order_id=>self.id).minimum('created_at')
    last_batch = Batch.find(:first, :conditions => ["number = ? and order_id = ?", Batch.where(:order_id=>self.id).maximum('number'), self.id])
    end_date = BatchHopperLot.where(:batch_id=>last_batch.id).maximum('created_at')

    start_date_string = start_date.strftime("%H:%M:%S") rescue "??:??:??"
    end_date_string = end_date.strftime("%H:%M:%S") rescue "??:??:??"
    duration_value = 0
    if not start_date.nil? and not end_date.nil?
      duration_value = (end_date.to_i - start_date.to_i) / 60.0
    end

    return {
      'start_date' => start_date_string,
      'end_date' => end_date_string,
      'duration' => duration_value
    }
  end

  def get_real_batches
    real_batches = 0
    Batch.where(:order_id => self.id).each do |batch|
      real_batches += 1 unless BatchHopperLot.where(:batch_id => batch.id).empty?
    end
    return real_batches
  end

  def create_code
    order = OrderNumber.first
    self.code = order.code.succ
    order.code = self.code
    order.save
  end

end
