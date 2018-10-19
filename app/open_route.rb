class DistanceJob < ActiveJob::Base
  queue_as :default

  OPENROUTE_API_KEY = '5b3ce3597851110001cf6248a55293af96ad4bdf94fa58435b55181a'

  def perform(trip_id)
    Trip.find(trip_id).update_attribute(:distance, 10)
  end
end
