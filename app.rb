require 'bundler'
require 'json'
require 'sqlite3'
require 'active_record'
require 'active_support'
require './lib/TimeHelper'
require './app/Trip'

ActiveRecord::Migration.verbose = false

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :trips, force: true do |t|
    t.string :start_address
    t.string :destination_address
    t.float :price
    t.float :distance
    t.date :date

    t.timestamps
  end
end

Bundler.require
Loader.autoload

class App < Rack::App

  headers 'Access-Control-Allow-Origin' => '*',
    'Access-Control-Expose-Headers' => 'X-My-Custom-Header, X-Another-Custom-Header'

  serializer do |object|
    object.to_s
  end

  desc 'Create trip'
  get '/api/trips' do
    unless params['start_address'] == nil
      Trip.create!(params)
      response.status = 201
      'Trip added!'
    else
      raise(StandardError,'Wrong parameters, dude!')
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
    {:error=>ex.message}
  end

end
