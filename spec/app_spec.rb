require 'spec_helper'
require 'rack/app/test'

describe App do

  include Rack::App::Test

  rack_app described_class

  describe '/api/trips' do
    subject {
      allow_any_instance_of(Trip).to receive(:fetch_distance).and_return(nil)

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

      allow_any_instance_of(Trip).to receive(:fetch_distance).and_return(nil)

      total_price = 0
      total_distance = 0
      days_in_current_week = Time.now.wday

      days_in_current_week.times do |day_index|
        price = (day_index + 1) * 5
        trip = create(:trip, price: price,
                 date: Timex.beginning_of_the_week + day_index.days)

        total_price += trip.price
        total_distance += trip.distance
      end

      # previous week
      create(:trip, price: 100,
             date: Timex.beginning_of_the_week - 1.day)

      # next week
      create(:trip, price: 100, date:
             Timex.beginning_of_the_week + 8.days)

      expect(JSON.parse(subject.body.join)).to eq({
        'total_distance' => "#{total_distance.round(0)}km",
        'total_price' => "#{total_price.round(2)}PLN"
      })
    end

  end

  describe 'Get monthly stats' do
    subject{ get(url: '/api/stats/monthly') }

    it { expect(subject.status).to eq 200 }


    it 'should give us monthly stats' do

      allow_any_instance_of(Trip).to receive(:fetch_distance).and_return(nil)

      create(:trip, date: Time.new(2018, 7, 4), price: 15, distance: 2)
      create(:trip, date: Time.new(2018, 7, 4), price: 25, distance: 4)
      create(:trip, date: Time.new(2018, 7, 4), price: 28.25, distance: 6)

      create(:trip, date: Time.new(2018, 7, 5), price: 15.5, distance: 3)

      Timecop.freeze(Time.new(2018, 7, 14)) do
        expect(JSON.parse(subject.body.join)).to eq(
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
          ]'
        ))
      end
    end

  end

  describe 'raises error when wrong parameters for adding a trip' do
    subject{ get(url: '/api/trips') }

    it { expect(subject.body.join).to eq '{:error=>"Validation failed: Start address can\'t be blank, Destination address can\'t be blank, Price can\'t be blank, Date can\'t be blank"}' }
  end

end
