require 'spec_helper'
require 'rack/app/test'

describe App do

  include Rack::App::Test

  rack_app described_class

  describe '/api/trips' do
    subject {
      get(url: '/api/trips',
          params: { start_address: 'Otwock',
                    destination_address: 'Plac Europejski 2, Warszawa, Polska',
                    price: '10',
                    date: '30-10-2018'}
         )
    }

    it { expect(subject.status).to eq 201 }
    it { expect(subject.body.join).to eq "Trip added!" }

    it 'should add it to the database' do
      expect(Trip.count).to eq 0
      subject
      expect(Trip.count).to eq 1
    end

  end

  describe 'Get weekly stats' do
    subject{ get(url: '/api/stats/weekly') }

    it { expect(subject.status).to eq 200 }

    it 'should give us weekly stats' do

      # 5, 10, 15, 20, 25
      5.times {|x| create(:trip, price: (x+1)*5) }

      expect(JSON.parse(subject.body.join)).to eq({
        'total_price' => '75.00PLN'
      })
    end

  end

  describe 'Get monthly stats' do
    subject{ get(url: '/api/stats/monthly') }

    it { expect(subject.body.join).to eq 'Monthly stats!'}

    it { expect(subject.status).to eq 200 }

  end

  describe 'raises error when wrong parameters for adding a trip' do
    subject{ get(url: '/api/trips') }

    it { expect(subject.body.join).to eq '{:error=>"Wrong parameters, dude!"}' }
  end

end
