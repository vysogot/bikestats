require_relative './trip'
require_relative './trip_decorator'

class TripStats

  include Formatex

  class << self

    def weekly
      week = Trip.select(
        arel_table[:id].maximum.as('id'),
        arel_table[:price].sum.as('total_price'),
        arel_table[:distance].sum.as('total_distance')
      ).where(
        date: Time.now.beginning_of_week..Time.now
      ).first

      week = TripDecorator.new(week)

      {
        total_distance: week.total_distance,
        total_price: week.total_price
      }
    end

    def monthly
      Trip.select(
        :date,
        arel_table[:price].average.as('avg_price'),
        arel_table[:distance].average.as('avg_distance'),
        arel_table[:distance].sum.as('total_distance')
      ).where(
        date: Time.now.beginning_of_month..Time.now
      ).group(:date).map do |day|

        day = TripDecorator.new(day)

        {
          day: day.date,
          total_distance: day.total_distance,
          avg_price: day.avg_price,
          avg_ride: day.avg_distance
        }
      end
    end

    private

    def arel_table
      Trip.arel_table
    end

  end
end
