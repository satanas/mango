require 'test_helper'

class BatchTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  def setup
    @batch = Batch.new :order => orders(:one), :schedule => schedules(:one), :user => users(:one), :number => 1, :total => 20, :start_date => time_stamp(Time.now), :end_date => time_stamp(Time.now + 60 * 60 * 24)
  end

  test "blank" do
    @batch = Batch.new
    assert_error_length 7, @batch
  end

  test "types" do
    assert_invalid @batch, :number, 'T', 1, /is not a number/
    assert_invalid @batch, :number, -1, 1, /must be greater than or equal to 0/
    assert_invalid @batch, :total, 'T', 1, /is not a number/
    assert_invalid @batch, :total, -1, 1, /must be greater than or equal to 0/
    assert_invalid @batch, :start_date, 'asninii', time_stamp(Time.now), /can't be blank/
    assert_invalid @batch, :end_date, 'asninii', time_stamp(Time.now), /can't be blank/
  end

  test "zassociations" do
    assert_invalid @batch, :order_id, 100, @batch.order.id, /doesn't exist/
    assert_obj_saved @batch
    assert_invalid @batch, :schedule_id, 100, @batch.schedule.id, /doesn't exist/
    assert_obj_saved @batch
    assert_invalid @batch, :user_id, 100, @batch.user.id, /doesn't exist/
    assert_obj_saved @batch
  end

end
