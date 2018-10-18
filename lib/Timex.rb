module Timex
  def self.beginning_of_the_week
    days_till_monday = (Time.now.wday - 1) * day_in_seconds
    date = (Time.now - days_till_monday).strftime('%Y-%m-%d')

    year, month, day = date.split('-')
    Time.new(year, month, day)
  end

  def self.beginning_of_the_month
    Time.new(Time.now.year, Time.now.month, 1)
  end

  def self.day_in_seconds
    24*60*60
  end
end
