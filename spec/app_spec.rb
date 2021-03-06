require 'spec_helper'
require 'rack/app/test'
require 'rack/test'

describe App do

  include Rack::App::Test
  include Rack::Test::Methods

  rack_app described_class

  def app
    App.new
  end

  before do
    allow_any_instance_of(TripService).to(
      receive(:fetch_distance).and_return(true)
    )
  end

  context 'Adding a new trip' do
    subject {
      post('/api/trips', {
        start_address: 'Poniatowskiego 2a, Otwock, Polska',
        destination_address: 'Plac Europejski 2, Warszawa, Polska',
        price: 10,
        date: '30-10-2018'
      })
    }

    it { expect(subject.status).to eq 201 }
    it { expect(subject.body).to include("Trip added!") }
    it { expect{subject}.to change{Trip.count}.from(0).to(1) }

    describe 'Getting an error when wrong parameters are passed' do
      subject{ post('/api/trips', {
        start_address: '',
        destination_address: '',
        price: '',
        date: ''
      }) }

      it { expect(subject.body).to include(
        "Start address is not in 'Street, City, Country' format",
        "Destination address is not in 'Street, City, Country' format",
        "Date is not in 'YYYY-mm-dd' format",
        "Price is not a number"
      )}
    end
  end

  context 'Getting the weekly stats' do
    subject{ get('/api/stats/weekly') }

    it { expect(subject.status).to eq 200 }

    it 'should get stats from the current week' do

      # freeze on Sunday
      Timecop.freeze(Time.new(2018, 10, 21)) do
        create(:trip, price: 15, distance: 15, date: Time.now)
        create(:trip, price: 5, distance: 5, date: Time.now - 3.days)
        create(:trip, price: 29.75, distance: 20, date: Time.now - 6.days)

        # outside of the current week
        create(:trip, price: 15.5, distance: 3, date: Time.now - 7.days)

        expect(JSON.parse(subject.body)).to eq(
          JSON.parse('{
            "total_distance": "40km",
            "total_price":    "49.75PLN"
          }')
        )
      end
    end

  end

  context 'Getting the monthly stats' do
    subject{ get('/api/stats/monthly') }

    it { expect(subject.status).to eq 200 }

    it 'should get stats from the current month' do

      create(:trip, date: Time.new(2018, 7, 4), price: 15, distance: 2)
      create(:trip, date: Time.new(2018, 7, 4), price: 25, distance: 4)
      create(:trip, date: Time.new(2018, 7, 4), price: 28.25, distance: 6)
      create(:trip, date: Time.new(2018, 7, 5), price: 15.5, distance: 3)

      # outside of the current month
      create(:trip, date: Time.new(2018, 6, 5), price: 15.5, distance: 3)

      Timecop.freeze(Time.new(2018, 7, 14)) do
        expect(JSON.parse(subject.body)).to eq(
          JSON.parse('[
            {
              "day":           "July, 4th",
              "total_distance": "12km",
              "avg_ride":       "4km",
              "avg_price":      "22.75PLN"
            },
            {
              "day":            "July, 5th",
              "total_distance": "3km",
              "avg_ride":       "3km",
              "avg_price":      "15.5PLN"
            }
          ]')
        )
      end
    end
  end
end
