class Trip < ActiveRecord::Base

  include Timex
  include Formatex

  validates_presence_of :start_address, :destination_address, :price, :date

  class << self
    def weekly_stats
      week = select(Arel.sql('sum(price) as total_price, sum(distance) as total_distance')).where(
        date: Timex.beginning_of_the_week..Time.now
      ).first

      {
        total_distance: Formatex.distance(week.total_distance),
        total_price: Formatex.price(week.total_price)
      }
    end

    def monthly_stats
      select(:date, Arel.sql('avg(price) as avg_price, avg(distance) as avg_distance, sum(distance) as total_distance')).where(
        date: Timex.beginning_of_the_month..Time.now
      ).group(:date).map do |day|
        {
          day: Formatex.date(day.date),
          total_distance: Formatex.distance(day.total_distance),
          avg_price: Formatex.price(day.avg_price),
          avg_ride: Formatex.distance(day.avg_distance)
        }
      end
    end
  end
end
