require 'test_helper'

class ShippingMethodTest < ActiveSupport::TestCase
  test "whether the tests are running" do
    assert true
  end

  #
  # INSTANCE METHODS
  #

  test "Shipping method can be created with an id, name, and cost" do
    name = "UPS Ground"
    id = 5
    cost = 4523

    s = ShippingMethod.new(id, name, cost)
    assert_equal s.id, id
    assert_equal s.name, name
    assert_equal s.cost, cost
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
