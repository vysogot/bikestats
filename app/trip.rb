class Trip < Rack::App
  include Mongoid::Document
  include TimeHelper
  store_in collection: "trips"

  field :start_address, type: String
  field :destination_address, type: String
  field :price, type: Float
  field :date, type: Date

  class << self
    def weekly_stats
      total_price = where(
        :date.gte => TimeHelper.beginning_of_the_week,
        :date.lte => Time.now
      ).sum(:price)

      total_price_formatted = "#{sprintf("%0.02f", total_price)}PLN"

      return {
        'total_distance': '40km',
        'total_price': total_price_formatted
      }
    end

    def monthly_stats
      total_price = where(
        :date.gte => TimeHelper.beginning_of_the_month,
        :date.lte => Time.now
      ).sum(:price)

      total_price_formatted = "#{sprintf("%0.02f", total_price)}PLN"

      return {
        'total_distance': '40km',
        'total_price': total_price_formatted
      }
    end
  end
end
