class Trip < ActiveRecord::Base

  include Formatex

  validates_format_of :start_address,
    :destination_address,
    :with => /.+,.+,.+/,
    message: "In not in 'Plac Europejski 2, Warszawa, Polska' format"

  validates_format_of :date,
    :with => /\d{4}-\d{2}-\d{2}/,
    message: "Is not in YYYY-mm-dd format"

  validates_numericality_of :price

  after_create :fetch_distance

  def fetch_distance
    DistanceJob.perform_later(id)
  end

  class << self
    def weekly_stats
      week = select(Arel.sql('sum(price) as total_price, sum(distance) as total_distance')).where(
        date: Time.now.beginning_of_week..Time.now
      ).first

      {
        total_distance: Formatex.distance(week.total_distance),
        total_price: Formatex.price(week.total_price)
      }
    end

    def monthly_stats
      select(:date, Arel.sql('avg(price) as avg_price, avg(distance) as avg_distance, sum(distance) as total_distance')).where(
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
