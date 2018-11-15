ENV['APP_ENV'] ||= 'development'
require './db'

require 'bundler'
require 'json'

Bundler.require
Loader.autoload

class App < Grape::API

  format :json
  prefix :api

  resource :trips do
    desc 'Create trip'

    params do
      requires :start_address,
        :destination_address,
        :date,
        :price, type: String
    end

    post do

      # work both with json and x-www-form-urlencoded
      params_json = nil

      if params.empty? && request.body.present?
        params_json = JSON.parse(request.body.read)
      end

      trip = TripService.new(params_json || params)

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
      TripStats.weekly
    end

    desc 'Get monthly stats'
    get :monthly do
      TripStats.monthly
    end
  end

  add_swagger_documentation hide_documentation_path: true,
    api_version: 'v1',
    info: {
      title: 'Bikeramp',
      description: 'Get the stats of your bike rides!'
    }

end
