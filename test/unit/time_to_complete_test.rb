require 'date'
require 'time'
require './test/minimal_test_helper'
require 'app/models/stats/time_to_complete'

FakeTask = Struct.new(:created_at, :completed_at)

class TimeToCompleteTest < Test::Unit::TestCase

  def now
    @now ||= Time.utc(2013, 1, 2, 3, 4, 5)
  end

  def day0
    @day0 ||= Time.utc(2013, 1, 2, 0, 0, 0)
  end

  def day2
    @day2 ||= Time.utc(2012, 12, 31, 0, 0, 0)
  end

  def day4
    @day4 ||= Time.utc(2012, 12, 29, 0, 0, 0)
  end

  def day6
    @day6 ||= Time.utc(2012, 12, 27, 0, 0, 0)
  end

  def fake_tasks
    @fake_tasks ||= [
      FakeTask.new(day2, now),
      FakeTask.new(day4, now),
      FakeTask.new(day6, now)
    ]
  end

  def test_empty_minimum
    assert_equal 0, Stats::TimeToComplete.new([]).min
  end

  def test_empty_maximum
    assert_equal 0, Stats::TimeToComplete.new([]).max
  end

  def test_empty_avg
    assert_equal 0, Stats::TimeToComplete.new([]).avg
  end

  def test_empty_min_sec
    assert_equal '00:00:00', Stats::TimeToComplete.new([]).min_sec
  end

  def test_minimum
    assert_equal 2.127835648148148, Stats::TimeToComplete.new(fake_tasks).min
  end

  def test_maximum
    assert_equal 6.127835648148148, Stats::TimeToComplete.new(fake_tasks).max
  end

  def test_avg
    assert_equal 4.127835648148148, Stats::TimeToComplete.new(fake_tasks).avg
  end

  def test_min_sec
    assert_equal '2 days 03:04:05', Stats::TimeToComplete.new(fake_tasks).min_sec
  end

  def test_min_sec_with_less_than_a_day
    task = FakeTask.new(day0, now)
    assert_equal '03:04:05', Stats::TimeToComplete.new([task]).min_sec
  end
end

