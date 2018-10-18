class Trip < ActiveRecord::Base

  include TimeHelper

  class << self
    def weekly_stats
      week = select(Arel.sql('sum(price) as total_price, sum(distance) as total_distance')).where(
        date: TimeHelper.beginning_of_the_week..Time.now
      ).first

      {
        total_distance: "#{week.total_distance.round(0)}km",
        total_price: "#{week.total_price.round(2)}PLN"
      }
    end

    def monthly_stats
      select(:date, Arel.sql('avg(price) as avg_price, avg(distance) as avg_distance, sum(distance) as total_distance')).where(
        date: TimeHelper.beginning_of_the_month..Time.now
      ).group(:date).map do |day|
        {
          day: day.date.strftime("%B, #{ActiveSupport::Inflector.ordinalize(day.date.mday)}"),
          total_distance: "#{day.total_distance.round(0)}km",
          avg_price: "#{day.avg_price.round(2)}PLN",
          avg_ride: "#{day.avg_distance.round(0)}km"
        }
      end
    end
  end
end
