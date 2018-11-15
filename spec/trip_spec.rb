require 'spec_helper'
require 'rack/app/test'

describe Trip do

  include Rack::App::Test

  rack_app described_class

  describe 'Validations' do

    it 'works with all parameters properly formatted' do
      expect {
        create(:trip)
      }.not_to raise_error
    end

    it 'doesnt work with wrong start address format' do
      expect {
        create(:trip, start_address: 'Plac Europejski 2, Warszawa')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt work with wrong destination address format' do
      expect {
        create(:trip, destination_address: 'Plac Europejski 2, Warszawa')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt work with worng price format' do
      expect {
        create(:trip, price: '17,-')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end


