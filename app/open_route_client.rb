class OpenRouteClient

  OPENROUTE_API_KEY = ENV['OPENROUTE_API_KEY'] || ""
  OPENROUTE_URI = 'https://api.openrouteservice.org/'
  HEADERS = { :accept => 'application/json; charset=utf-8' }

  class << self

    def fetch_distance(start_address, destination_address)
      start = locate(start_address)
      destination = locate(destination_address)

      coordinates = start[:latitude].to_s + "," + start[:longitude].to_s + "|" +
        destination[:latitude].to_s + "," + destination[:longitude].to_s

      api_endpoint = OPENROUTE_URI + 'directions'

      params = { params: {
        api_key: OPENROUTE_API_KEY,
        coordinates: coordinates,
        profile: 'cycling-road'
      } }.merge(HEADERS)

      response = RestClient.get(api_endpoint, params)
      json_body = JSON.parse(response.body)

      distance_in_meters = json_body["routes"].first["summary"]["distance"]
      distance_in_kilometers = (distance_in_meters/1000).round(0)

      return distance_in_kilometers
    end

    private

    def locate(address)
      api_endpoint = OPENROUTE_URI + 'geocode/search'

      params = { params: {
        api_key: OPENROUTE_API_KEY,
        text: address
      } }.merge(HEADERS)

      response = RestClient.get(api_endpoint, params)
      json_body = JSON.parse(response.body)

      coordinates = json_body["features"].first["geometry"]["coordinates"]

      return {
        latitude: coordinates[0],
        longitude: coordinates[1]
      }
    end

  end
end
