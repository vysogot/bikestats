require 'bundler'
require 'json'

require './db'
require './lib/timex'
require './lib/formatex'
require './app/distance_job'
require './app/trip'

Bundler.require
Loader.autoload

class App < Rack::App

  headers 'Access-Control-Allow-Origin' => '*'

  serializer do |object|
    object.to_s
  end

  desc 'Create trip'
  get '/api/trips' do
    if Trip.create!(params)
      response.status = 201
      'Trip added!'
    end
  end

  desc 'Get weekly stats'
  get '/api/stats/weekly' do
    Trip.weekly_stats.to_json
  end

  desc 'Get monthly stats'
  get '/api/stats/monthly' do
    Trip.monthly_stats.to_json
  end

  error StandardError, NoMethodError do |ex|
    { :error => ex.message}
  end

end
