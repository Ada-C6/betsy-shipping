require 'httparty'

module ShippingService::APIClient

  FAKE_METHOD_DATA = [
    {id: 1, name: "UPS Ground", cost: 20.41},
    {id: 2, name: "UPS Second Day Air", cost: 82.71},
    {id: 3, name: "FedEx Ground", cost: 20.17},
    {id: 4, name: "FedEx 2 Day", cost: 68.46},
  ]



  def methods_for_order(order)
    options = HTTParty.post("http://localhost:3001/shipping_quotes",
      { :body => order.to_json,
        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}  })
    return options.to_hash
  end

  def get_method(id)
    # The real implementation should send this ID off to
    # the API and get back the details for a specific
    # shipping method.
    #
    # Instead we'll just return the fake data from above
    data = data_for_id(id)
    if data.nil?
      raise ShippingService::ShippingMethodNotFound.new
    end

    method_from_data(data)
  end

  private

  def data_for_id(id)
    if id.nil?
      raise ShippingService::ShippingMethodNotFound.new
    end

    FAKE_METHOD_DATA.select { |data| data[:id] == id.to_i }.first
  end

  def method_from_data(data)
    ShippingService::ShippingMethod.new(data[:id], data[:name], data[:cost])
  end
end
