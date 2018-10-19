# Bikeramp

Simple API for adding bike trips and getting weekly and monthly stats. It gets the distances between the start address and destination address through a OpenRouteService API.

## Install

  $ bundle install
  $ bundle exec rspec
  $ bundle exec rackup

## Example request

Run ./curl.sh to create a trip

## API

POST /api/trips

params:
* start_address: String
* destination_address: String
* price: Numeric
* date: String

GET /api/stats/weekly

GET /api/stats/monthly
