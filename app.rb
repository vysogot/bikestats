ENV['APP_ENV'] ||= 'development'

require 'bundler'
require 'json'

require './db'
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

  desc 'Describe API'
  get '/' do
    { routes: [
      { post: [
        { "/api/trips": { params: {
          start_address: 'String',
          destination_addres: 'String',
          price: 'Numeric',
          date: 'String' } } }
      ] },
      { get: [
        { "/api/stats/weekly": { params: {} } },
        { "/api/stats/monthly": { params: {} } }
      ] }
    ] }.to_json
  end

  desc 'Create trip'
  post '/api/trips' do

    # hack to work both for rspec and curl
    # replacing params makes it empty
    params_json = nil

    if params.empty? && request.body.present?
      params_json = JSON.parse(request.body.read)
    end

    if Trip.create!(params_json || params)
      response.status = 201
      { success: 'Trip added!' }
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

  error StandardError, NoMethodError do |error|
    { error: error.message }.to_json
  end

end
