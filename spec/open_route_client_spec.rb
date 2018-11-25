require 'spec_helper'

describe OpenRouteClient do

  it "gets the distance between two pairs of coordinates" do
    response = double(:response)

    first = '{ "features": [ { "geometry": { "coordinates": [30, 50] } } ] }'
    second = '{ "features": [ { "geometry": { "coordinates": [31, 50] } } ] }'
    third = '{ "routes": [ { "summary": { "distance": 1000 } } ] }'

    allow(response).to receive(:body).and_return(first, second, third)
    allow(RestClient).to receive(:get).and_return(response)

    expect(OpenRouteClient.fetch_distance('start', 'destination')).to eq 1
  end
end
