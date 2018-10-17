class Trip < Rack::App
  include Mongoid::Document
  store_in collection: "trips"

  field :start_address, type: String
  field :destination_address, type: String
  field :price, type: Float
  field :date, type: Date

  class << self
    def weekly_stats
      { 'total_price': "#{sprintf("%0.02f", sum(:price))}PLN" }
    end
  end
end
