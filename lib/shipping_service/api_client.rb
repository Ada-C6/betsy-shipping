require 'httparty'

module ShippingService::APIClient
  attr_reader :service_name, :cost

	# def initialize(details)
	# 	@name = details[:carrier_service]
 #    @cost = details[:carrier_rate]
 #  end
 	BASE_URL = "https://shipping-service-api.herokuapp.com/shipping/usps?"



  def methods_for_order(order, weight)
    # The real implementation should use the order's
    # shipping details, calculate the weight of every
    # product in the order, and send that info to the API
    # along with a pre-defined "source" address.


    my_weight = weight
    my_zip = 99518
    my_state = 'Alaska'
    my_city = 'Anchorage'
		url = "https://shipping-service-api.herokuapp.com/shipping/usps?" +"weight=#{my_weight}" +"&zip=#{my_zip}" +"&state=#{my_state}" +"&city=#{my_city}"
    #MY METHOD
    response = HTTParty.get(url)

 		options = []

 		response['rates'].each do |shipping_option|
 			details = {}
 			details[:carrier_service] = shipping_option["service_name"]
 			details[:carrier_rate] = shipping_option["package_rates"][-1]["rate"]
 			details[:id] = shipping_option["service_code"]
 			estimate = ShippingService.new(details)

 			# estimate = ShippingEstimate.new(shipping_option)
 			options << estimate
 		end

 		return options


  end

  def get_method(id)
    # The real implementation should send this ID off to
    # the API and get back the details for a specific
    # shipping method.
    #
    # Instead we'll just return the fake data from above
    data = data_for_id(id)  #METHOD IS BELOW
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
    ShippingService.new(data[:id], data[:name], data[:cost])
  end
end
