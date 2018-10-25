ENV['APP_ENV'] ||= 'development'
require './db'

require 'bundler'
require 'json'

Bundler.require
Loader.autoload

class App < Rack::App

  headers 'Access-Control-Allow-Origin' => '*'

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

    # work both with json and x-www-form-urlencoded
    params_json = nil

    if params.empty? && request.body.present?
      params_json = JSON.parse(request.body.read)
    end

    if Trip.create!(params_json || params)
      response.status = 201
      { success: 'Trip added!' }.to_json
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

  error ActiveRecord::RecordInvalid do |error|
    { error: error.message }.to_json
  end

end
