require 'httparty'

module ShippingService::APIClient

  # FAKE_METHOD_DATA = [
  #   {id: 1, name: "UPS Ground", cost: 20.41},
  #   {id: 2, name: "UPS Second Day Air", cost: 82.71},
  #   {id: 3, name: "FedEx Ground", cost: 20.17},
  #   {id: 4, name: "FedEx 2 Day", cost: 68.46},
  # ]

  BASE_URL = "https://ourapi.herokuapp.com/"
  BASE_SEARCH = "&origin_country=US&origin_state=WA&origin_city=Seattle&origin_zip=98102&destination_country=US"

  def methods_for_order(order)
    weight = order.total_weight
    url = BASE_URL + "search?q=" + "&weight=#{ weight }" + BASE_SEARCH + "&destination_state=#{ order.state }" + "&destination_city=#{ order.city }" + "&destination_zip=#{ order.billing_zip }"

    data = HTTParty.get(url)
    shipping_list = []
    if data
      data.each do |shipping|
        wrapper = ShippingService::ShippingMethod.new(shipping["id"], shipping["name"], shipping["cost"])
        shipping_list << wrapper
      end
    end
    return shipping_list



    #
    # Instead we'll just return the fake data from above
    # FAKE_METHOD_DATA.map do |data|
    #   method_from_data(data)
    # end
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

    # Ummmmm ... this might work???
    # shipping_method_id.select { |data| data[:id] == id.to_i }.first

    FAKE_METHOD_DATA.select { |data| data[:id] == id.to_i }.first
  end

  def method_from_data(data)
    ShippingService::ShippingMethod.new(data[:id], data[:name], data[:cost])
  end
end
