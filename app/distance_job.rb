require 'active_job'
require 'rest-client'

class DistanceJob < ActiveJob::Base

  OPENROUTE_API_KEY = ENV['OPENROUTE_API_KEY'] || ""
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
    response = RestClient.get(OPENROUTE_URI +
                             'geocode/search?api_key=' + OPENROUTE_API_KEY +
                             '&text=' + URI.encode(address),
                             HEADERS)

    json_body = JSON.parse(response.body)
    coordinates = json_body["features"].first["geometry"]["coordinates"]

    return {
      latitude: coordinates[0],
      longitude: coordinates[1]
    }
  end

  def fetch_distance(start, destination)
    coordinates = start[:latitude].to_s + "," + start[:longitude].to_s + "|" +
                  destination[:latitude].to_s + "," + destination[:longitude].to_s

    response = RestClient.get(OPENROUTE_URI +
                              'directions?api_key=' + OPENROUTE_API_KEY +
                              '&coordinates=' + URI.encode(coordinates) +
                              '&profile=cycling-road',
                              HEADERS)

    json_body = JSON.parse(response.body)
    distance_in_meters = json_body["routes"].first["summary"]["distance"]
    distance_in_kilometers = (distance_in_meters/1000).round(0)

    return distance_in_kilometers
  end
end
