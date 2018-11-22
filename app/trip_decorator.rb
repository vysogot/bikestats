class TripDecorator

  include Formatex
  delegate_missing_to :trip

  def initialize(component)
    @component = component
  end

  def total_distance
    Formatex.distance(@component.total_distance)
  end

  def total_price
    Formatex.price(@component.total_price)
  end

  def avg_price
    Formatex.price(@component.avg_price)
  end

  def avg_distance
    Formatex.distance(@component.avg_distance)
  end

  def date
    Formatex.date(@component.date)
  end
end
