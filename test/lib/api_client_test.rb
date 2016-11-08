require 'test_helper'

class ApiClientTest < ActiveSupport::TestCase
  test "whether the tests are running" do
    assert true
  end

  test "methods_for_order returns an array of shipping options" do
    VCR.use_cassette("shipping_methods") do
      shipping_methods = ShippingService::APIClient.methods_for_order(orders(:completed))
      assert_kind_of Array, shipping_methods
      shipping_methods.each do |method|
        assert_kind_of ShippingService::ShippingMethod, method
      end
    end
  end
end
