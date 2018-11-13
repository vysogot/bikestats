require 'active_job'
require 'rest-client'

class DistanceJob < ActiveJob::Base
  def perform(trip_id)
    trip = Trip.find(trip_id)
    distance = OpenRouteClient.fetch_distance(trip.start_address, trip.destination_address)
    trip.update_attribute(:distance, distance)
  end
end

