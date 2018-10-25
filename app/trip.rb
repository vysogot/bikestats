class Trip < ActiveRecord::Base

  include Formatex

  validates_format_of :start_address,
    :destination_address,
    :with => /.+,.+,.+/,
    message: "In not in 'Street, City, Country' format"

  validates_format_of :date,
    :with => /\d{4}-\d{2}-\d{2}/,
    message: "Is not in 'YYYY-mm-dd' format"

  validates_numericality_of :price

  after_create :fetch_distance

  def fetch_distance
    DistanceJob.perform_later(id)
  end

  class << self
    def weekly_stats
      week = select(
          arel_table[:id].maximum.as('id'),
          arel_table[:price].sum.as('total_price'),
          arel_table[:distance].sum.as('total_distance')
      ).where(
          date: Time.now.beginning_of_week..Time.now
      ).first

      {
        total_distance: Formatex.distance(week.total_distance),
        total_price: Formatex.price(week.total_price)
      }
    end

    def monthly_stats
      select(
        :date,
        arel_table[:price].average.as('avg_price'),
        arel_table[:distance].average.as('avg_distance'),
        arel_table[:distance].sum.as('total_distance')
      ).where(
        date: Time.now.beginning_of_month..Time.now
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
