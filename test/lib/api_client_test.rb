require 'test_helper'

class ApiClientTest < ActiveSupport::TestCase
  test "whether the tests are running" do
    assert true
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
