module ShippingService::APIClient

  FAKE_METHOD_DATA = [
    {id: 1, name: "UPS Ground", cost: 20.41},
    {id: 2, name: "UPS Second Day Air", cost: 82.71},
    {id: 3, name: "FedEx Ground", cost: 20.17},
    {id: 4, name: "FedEx 2 Day", cost: 68.46},
  ]

  BASE_URL = "https://nj-shipping-api.herokuapp.com"

  def methods_for_order(order)
    destination = {city: order.city, state: order.state, zip: order.billing_zip, country: 'US'}
    origin = {city: 'Beverly Hills', state: 'CA', zip: '90210', country: 'US'}
    packages = {weight: order.total_weight, size: [10,10,10]}

    url = BASE_URL + "/shippings"

    data = HTTParty.get(url,
      query: {
        "packages" => "#{packages}",
        "origin" => "#{origin}",
        "destination" => "#{destination}"
      })

    response = data.parsed_response
    mapped = response.map.with_index {|datum, i|  method_from_data(i, datum)}
    return mapped
  end


  def get_method(carrier_name, order)
    carrier = carrier_name
    destination = {city: order.city, state: order.state, zip: order.billing_zip, country: 'US'}
    origin = {city: 'Beverly Hills', state: 'CA', zip: '90210', country: 'US'}
    packages = {weight: order.total_weight, size: [10,10,10]}

    url = BASE_URL + "/shippings/#{carrier}"

    data = HTTParty.get(url,
      query: {
        "packages" => "#{packages}",
        "origin" => "#{origin}",
        "destination" => "#{destination}"
      })

    response = data.parsed_response
    mapped = response.map.with_index {|datum, i|  method_from_data(i, datum)}
    return mapped
  end

  def method_select(id, shipping_methods)
    data = data_for_id(id, shipping_methods)
    if data.nil?
      raise ShippingService::ShippingMethodNotFound.new
    end

    data
  end

  private

  def data_for_id(id, shipping_methods)

    if id.nil?
      raise ShippingService::ShippingMethodNotFound.new
    end

    shipping_methods.select { |data| data.id == id.to_i }.first
  end

  def method_from_data(i, data)
    ShippingService::ShippingMethod.new(i, data[0], data[1])
  end
end
