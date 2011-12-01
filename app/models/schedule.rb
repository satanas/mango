class Schedule < ActiveRecord::Base
  has_many :batch

  validates_uniqueness_of :name
  validates_presence_of :start_hour, :end_hour
end
