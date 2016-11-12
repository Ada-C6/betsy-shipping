class ShippingService::ShippingMethod

  attr_reader :id, :name, :cost

  def initialize(name, cost)
    @name = name
    @cost = cost
  end


end
