require_relative './trip'

class TripService

  attr_accessor :trip
  delegate_missing_to :trip

  def initialize(params)
    self.trip = Trip.new(params)
  end

  def save
    fetch_distance if self.trip.save
  end

  private

  def fetch_distance
    DistanceJob.perform_later(self.trip.id)
  end

end
