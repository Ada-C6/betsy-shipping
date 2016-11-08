class ShippingService::ShippingMethod

  attr_reader :id, :name, :cost

  def initialize(id, name, cost)
    @id = id
    @name = name
    @cost = cost
  end

  class << self
    attr_reader :shipping_methods
  end

  def self.ship(order = nil)
    @shipping_methods ||= ApiClient.methods_for_order(order)
  end

  def self.reset
    @shipping_methods = nil
  end
end
