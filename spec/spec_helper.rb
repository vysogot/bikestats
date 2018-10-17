require_relative '../app'
require 'json'
require 'database_cleaner'
require 'factory_bot'

Mongoid.load!(File.dirname(__FILE__) + "/../mongoid.yml", :test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
