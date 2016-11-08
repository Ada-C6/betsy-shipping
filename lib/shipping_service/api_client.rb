require 'httparty'

module ShippingService::APIClient

  FAKE_METHOD_DATA = [
    {id: 1, name: "UPS Ground", cost: 20.41},
    {id: 2, name: "UPS Second Day Air", cost: 82.71},
    {id: 3, name: "FedEx Ground", cost: 20.17},
    {id: 4, name: "FedEx 2 Day", cost: 68.46},
  ]

  BOX_SIZE = [15, 10, 4.5]
  BASE_URL = "localhost:3210/"

  def methods_for_order(order)
    total_weight = 0
    order.orderitems.each do |o|
      product = Product.find(o.product_id)
      total_weight += product.weight * o.quantity
    end

    package = {weight: total_weight, box_size: BOX_SIZE}

    origin = {country: 'US', state: 'WA', city: 'Seattle', zip: '98161'}

    destination = {country: 'US', state: order.state, city: order.city, zip: order.billing_zip}

    query = {package: package, origin: origin, destination: destination}

    url = BASE_URL + "search?query=#{ query }"
    data = HTTParty.get(url)


    # ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    #
    # # Check out USPS for comparison...
    # usps = ActiveShipping::USPS.new(login: '677JADED7283')
    # response = usps.find_rates(origin, destination, packages)
    #
    # usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # # returns an array of usps options

    # # The real implementation should use the order's
    # # shipping details, calculate the weight of every
    # # product in the order, and send that info to the API
    # # along with a pre-defined "source" address.
    # #
    # # Instead we'll just return the fake data from above
    # FAKE_METHOD_DATA.map do |data|
    #   method_from_data(data)
    # end
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
