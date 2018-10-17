class Trip < Rack::App
  include Mongoid::Document
  store_in collection: "trips"

  field :start_address, type: String
  field :destination_address, type: String
  field :price, type: Float
  field :date, type: Date
end
