class Order < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :client
  belongs_to :user
  belongs_to :product
  has_many :batch

  validates_presence_of :recipe_id, :user_id
  validates_uniqueness_of :code
  validates_numericality_of :prog_batches, :real_batches, :only_integer => 0, :greater_than_or_equal_to => 0
  validates_associated :recipe, :client, :user

  before_validation :validates_real_batchs

  def validates_real_batchs
    self.real_batches = 0 if self.real_batches.nil?
    return true
  end

  def calculate_start_date
    Batch.where(:order_id=>self.id).minimum('start_date').strftime("%d/%m/%Y %H:%M:%S")
  end

  def calculate_end_date
    Batch.where(:order_id=>self.id).maximum('end_date').strftime("%d/%m/%Y %H:%M:%S")
  end

  def calculate_duration
    start_date = Batch.where(:order_id=>self.id).minimum('start_date')
    end_date = Batch.where(:order_id=>self.id).maximum('end_date')
    return {
      'start_date' => start_date.strftime("%d/%m/%Y %H:%M:%S"),
      'end_date' => end_date.strftime("%d/%m/%Y %H:%M:%S"),
      'duration' => (end_date.to_i - start_date.to_i) / 60.0
    }
  end

  def get_real_batches
    Batch.where(:order_id => self.id).count #We are not using this field => @order.real_batches.to_s
  end

end
