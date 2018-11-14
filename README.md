# Bikeramp

Rack based API for adding bike trips and getting weekly and monthly stats. It gets the distances between the start address and destination address through a OpenRouteService API.

## Install

```
  $ bundle install
  $ bundle exec rspec
```

## Running the app

The app uses OpenRouteService API so be sure to provide it with the key

`OPENROUTE_API_KEY=your_key_here bundle exec rackup`

## Example requests

Run `./curl.sh` to create 3 trips and see the stats. Make sure you have `json_pp` available.

## API

```
POST /api/trips

params:
- start_address: String
- destination_address: String
- price: Numeric
- date: String

GET /api/stats/weekly
GET /api/stats/monthly
```

Also, check out Swagger documentation at `/api/swagger_doc`
