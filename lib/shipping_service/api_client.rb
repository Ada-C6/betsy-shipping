require 'httparty'

module ShippingService::APIClient

  BASE_URL = "https://heathership.herokuapp.com/"
  BASE_SEARCH = "&origin_country=US&origin_state=WA&origin_city=Seattle&origin_zip=98122&destination_country=US"

  def methods_for_order(order)
    weight = (order.total_weight) * 16 # Gives weight in ounces for shipment purposes
    url = BASE_URL + "search?" + "weight=#{ weight }" + BASE_SEARCH + "&destination_state=#{ order.state }" + "&destination_city=#{ order.city }" + "&destination_zip=#{ order.billing_zip }"

    data = HTTParty.get(url)
    shipping_list = []
    if data
      data.parsed_response.each do |shipping|
        wrapper = ShippingService::ShippingMethod.new(shipping["id"], shipping["name"], shipping["cost"]/100)
        shipping_list << wrapper
      end
    end
    return shipping_list
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
    shipping_method_id.select { |data| data[:id] == id.to_i }.first
  end

  def method_from_data(data)
    ShippingService::ShippingMethod.new(data[:id], data[:name], data[:cost])
  end
end
