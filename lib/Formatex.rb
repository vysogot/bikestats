require 'active_support'

module Formatex
  def self.distance(value)
    value ? "#{value.round(0)}km" : '0km'
  end

  def self.price(value)
    value ? "#{value.round(2)}PLN" : '0PLN'
  end

  def self.date(value)
    value.strftime("%B, #{ActiveSupport::Inflector.ordinalize(value.mday)}")
  end
end
