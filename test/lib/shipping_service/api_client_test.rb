require 'test_helper'
include ShippingService::APIClient

class ApiClientTest < ActiveSupport::TestCase
  ORDER = {id: 1, name: "Person", weight: 3.5, length: 13, width: 2.5, height: 8, country: "US", state: "AK", city: "Anchorage", billing_zip: 99501 }

  test "the truth" do
    assert true
  end

  test "methods_for_order works" do
    VCR.use_cassette("shipping_service_call") do
      options = methods_for_order(ORDER)
      assert_kind_of Hash, options
      assert_not_nil options

      carriers = %w(ups_rates usps_rates)
      n = 0
      options.each do |k,v|
        assert_equal k, carriers[n]
        n += 1
      end
    end
  end

end
