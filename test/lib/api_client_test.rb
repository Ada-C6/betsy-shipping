require 'test_helper'

class ApiClientTest < ActiveSupport::TestCase
  test "whether the tests are running" do
    assert true
  end

  test "methods_for_order returns an array of shipping options" do
    VCR.use_cassette("shipping_options") do
      shipping_options = ShippingService::APIClient.methods_for_order(order)
      assert_kind_of Array, shipping_options
      shipping_options.each do |option|
        assert_kind_of ShippingOption, shipping_option
      end
    end
  end

  # test "listrecipes returns an array of recipes" do
  #   VCR.use_cassette("recipes") do
  #     recipes = EdamamApiWrapper.listrecipes("chicken", 1)
  #     assert_kind_of Array, recipes
  #     recipes.each do |recipe|
  #       assert_kind_of Recipe, recipe
  #     end
  #   end
  # end

end
