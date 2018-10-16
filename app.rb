require 'bundler'
require 'json'
Bundler.require
Loader.autoload

class App < Rack::App

  mount SomeAppClass

  headers 'Access-Control-Allow-Origin' => '*',
    'Access-Control-Expose-Headers' => 'X-My-Custom-Header, X-Another-Custom-Header'

  serializer do |object|
    object.to_s
  end

  desc 'Create trip'
  get '/api/trips' do
    p params
    unless params['start_address'] == nil
      response.status = 201
      'Trip added!'
    else
      raise(StandardError,'Wrong parameters, dude!')
    end
  end

  desc 'Get weekly stats'
  get '/api/stats/weekly' do
    'Weekly stats!'
  end

  desc 'Get monthly stats'
  get '/api/stats/monthly' do
    'Monthly stats!'
  end

  error StandardError, NoMethodError do |ex|
    {:error=>ex.message}
  end

end
