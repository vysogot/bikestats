class Trip < Rack::App
  include Mongoid::Document
  store_in collection: "trips"

  field :start_address, type: String
  field :destination_address, type: String
  field :price, type: Float
  field :date, type: Date

  class << self
    def weekly_stats
      total_price = where(
        :date.gte => Time.now - 7*24*60*60,
        :date.lte => Time.now
      ).sum(:price)

      { 'total_price': "#{sprintf("%0.02f", total_price)}PLN" }
    end
  end
end
