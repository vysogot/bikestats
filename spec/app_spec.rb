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

      total_price = 0
      days_in_current_week = Time.now.wday

      days_in_current_week.times do |day_index|
        price = (day_index + 1) * 5
        total_price += price

        create(:trip, price: price,
               date: TimeHelper.beginning_of_the_week +
               day_index * TimeHelper.day_in_seconds)
      end

      # previous week
      create(:trip, price: 100,
             date: TimeHelper.beginning_of_the_week -
             TimeHelper.day_in_seconds)

      # next week
      create(:trip, price: 100, date:
             TimeHelper.beginning_of_the_week +
             8 * TimeHelper.day_in_seconds)

      expect(JSON.parse(subject.body.join)).to eq({
        'total_distance' => '40km',
        'total_price' => "#{total_price}.00PLN"
      })
    end

  end

  describe 'Get monthly stats' do
    subject{ get(url: '/api/stats/monthly') }

    it { expect(subject.status).to eq 200 }


    it 'should give us monthly stats' do

      total_price = 0
      days_in_current_month = Time.now.mday

      days_in_current_month.times do |day_index|
        price = (day_index + 1) * 5
        total_price += price

        create(:trip, price: price,
               date: TimeHelper.beginning_of_the_month +
               day_index * TimeHelper.day_in_seconds)
      end

      # previous month
      create(:trip, price: 100,
             date: TimeHelper.beginning_of_the_month -
             TimeHelper.day_in_seconds)

      # next month
      create(:trip, price: 100, date:
             TimeHelper.beginning_of_the_month +
             32 * TimeHelper.day_in_seconds)

      expect(JSON.parse(subject.body.join)).to eq({
        'total_distance' => '40km',
        'total_price' => "#{total_price}.00PLN"
      })
    end

  end

  describe 'raises error when wrong parameters for adding a trip' do
    subject{ get(url: '/api/trips') }

    it { expect(subject.body.join).to eq '{:error=>"Wrong parameters, dude!"}' }
  end

end
