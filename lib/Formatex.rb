module Formatex
  def self.distance(value)
    "#{value.round(0)}km"
  end

  def self.price(value)
    "#{value.round(2)}PLN"
  end

  def self.date(value)
    value.strftime("%B, #{ActiveSupport::Inflector.ordinalize(value.mday)}")
  end
end
