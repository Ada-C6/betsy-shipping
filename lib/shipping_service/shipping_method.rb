class ShippingService::ShippingMethod

  attr_reader :id, :name, :cost

  def initialize(id, name, cost)
    @id = id
    @name = name
    @cost = (cost.to_f)/100.00
  end
end
