class Order < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :client
  belongs_to :user
  belongs_to :product
  
  validates_presence_of :code, :prog_batchs, :recipe_id, :client_id, :user_id, :product_id
  validates_uniqueness_of :code
  validates_associated :recipe, :client, :user, :product
end
