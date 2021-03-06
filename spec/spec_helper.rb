ENV['APP_ENV'] = 'test'

require_relative '../app'

require './lib/formatex'
require './app/trip'

require 'json'
require 'database_cleaner'
require 'factory_bot'
require 'timecop'
require 'byebug'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
