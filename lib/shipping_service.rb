class ShippingService
  # You will need to implement each of the methods in this module
  # to interact with your API server and produce correct results.
  # Check out: lib/shipping_service/api_client.rb
  extend ShippingService::APIClient

  # You will also need to implement the methods in
  # lib/shipping_service/shipping_method.rb

  def methods_for_order(order)
    weight = order.total_weight
    info = { weight: weight,
    origin: {origin_country: "US",
    origin_state: "WA",
    origin_city: "Seattle",
    origin_zip: "98104"},
      destination: {
      destination_country: "US",
      destination_state: "#{order.state}",
      destination_city: "#{order.city}",
      destination_zip: "#{order.billing_zip}"}}.to_json


    url = BASE_URL
    info = HTTParty.post(url, body: info, headers: ["Content-Type"])
    # ship = []

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
end
