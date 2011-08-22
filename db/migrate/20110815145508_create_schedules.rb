class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.string :name
      t.time :start_hour
      t.time :end_hour
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
