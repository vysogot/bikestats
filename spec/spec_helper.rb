require_relative '../app'
require 'database_cleaner'

Mongoid.load!(File.dirname(__FILE__) + "/../mongoid.yml", :test)

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
