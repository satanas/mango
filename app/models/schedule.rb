class Schedule < ActiveRecord::Base

  validates_uniqueness_of :name
  validates_presence_of :start_hour, :end_hour
end
