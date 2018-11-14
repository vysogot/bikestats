ENV['APP_ENV'] ||= 'development'
require './db'

require 'bundler'
require 'json'

Bundler.require
Loader.autoload

class App < Grape::API

  format :json
  prefix :api

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

  resource :trips do
    desc 'Create trip'
    post do

      # work both with json and x-www-form-urlencoded
      params_json = nil

      if params.empty? && request.body.present?
        params_json = JSON.parse(request.body.read)
      end

      trip = Trip.new(params_json || params)

      if trip.save
        status = 201
        return { success: 'Trip added!' }
      else
        trip.errors.full_messages
      end
    end
  end

  resource :stats do
    desc 'Get weekly stats'
    get :weekly do
      Trip.weekly_stats
    end

    desc 'Get monthly stats'
    get :monthly do
      Trip.monthly_stats
    end
  end

  #error ActiveRecord::RecordInvalid do |error|
  #  { error: error.message }.to_json
  #end

end
