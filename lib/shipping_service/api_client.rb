module ShippingService::APIClient

  FAKE_METHOD_DATA = [
    {id: 1, name: "UPS Ground", cost: 20.41},
    {id: 2, name: "UPS Second Day Air", cost: 82.71},
    {id: 3, name: "FedEx Ground", cost: 20.17},
    {id: 4, name: "FedEx 2 Day", cost: 68.46},
  ]

  def methods_for_order(order)
    # total_weight in order.rb calculates weight
    # API gives back shipping options, as in fake data above
    # Billing zip code needs to be 5 digits - for now, just do that
    # - weight (pounds)
    # - origin_country = 'US'
    # - origin_state = 'WA'
    # - origin_city = 'Seattle'
    # - origin_zip = '98102'
    # - destination_country = 'US'
    # - destination_state
    # - destination_city
    # - destination_zip

    # Probably USPS - based on login information


    # The real implementation should use the order's
    # shipping details, calculate the weight of every
    # product in the order, and send that info to the API
    # along with a pre-defined "source" address.
    #
    # Instead we'll just return the fake data from above
    FAKE_METHOD_DATA.map do |data|
      method_from_data(data)
    end
  end

  def get_method(id)
    # User chooses which shipping id to implement and sends to API
    # API sends back delivery and tracking information???
    # sends shipping_method

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
