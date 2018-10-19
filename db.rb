require 'sqlite3'
require 'active_record'

ActiveRecord::Migration.verbose = false

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db.sqlite3'
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
