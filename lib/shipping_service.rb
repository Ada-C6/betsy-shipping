class ShippingService
  # You will need to implement each of the methods in this module
  # to interact with your API server and produce correct results.
  # Check out: lib/shipping_service/api_client.rb
  extend ShippingService::APIClient

  attr_reader :service_name, :cost, :id

	def initialize(details)
		@service_name = details[:carrier_service]
    @cost = details[:carrier_rate]
    @id = details[:service_code]
  end

  # You will also need to implement the methods in
  # lib/shipping_service/shipping_method.rb
end
