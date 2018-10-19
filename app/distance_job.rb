require 'active_job'
require 'rest-client'

class DistanceJob < ActiveJob::Base

  OPENROUTE_API_KEY = '5b3ce3597851110001cf6248a55293af96ad4bdf94fa58435b55181a'
  OPENROUTE_URI = 'https://api.openrouteservice.org/'
  HEADERS = { :accept => 'application/json; charset=utf-8' }

  def perform(trip_id)
    trip = Trip.find(trip_id)

    start = locate(trip.start_address)
    destination = locate(trip.destination_address)

    distance = fetch_distance(start, destination)

    trip.update_attribute(:distance, distance)
  end

  def locate(address)
    response = RestClient.get(OPENROUTE_URI + 'geocode/search?api_key=' + OPENROUTE_API_KEY +
                              '&text=' + URI.encode(address), HEADERS)
    coordinates = JSON.parse(response.body)["features"].first["geometry"]["coordinates"]

    { latitude: coordinates[0], longitude: coordinates[1] }
  end

  def fetch_distance(start, destination)
    coordinates = "#{start[:latitude]},#{start[:longitude]}|#{destination[:latitude]},#{destination[:longitude]}"

    response = RestClient.get(OPENROUTE_URI + 'directions?api_key=' + OPENROUTE_API_KEY +
                              '&coordinates=' + URI.encode(coordinates) +
                              '&profile=cycling-road', HEADERS)

    distance_in_meters = JSON.parse(response.body)["routes"].first["summary"]["distance"]
    (distance_in_meters/1000).round(0)
  end
end
