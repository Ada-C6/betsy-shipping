require 'httparty'
# require 'awesome_print'

class Api_Wrapper
  # would we need to change how we calls these constants?
  BASE_URL = "https://leah-shipping.herokuapp.com"
  GITHUB_KEY = ENV["GITHUB_KEY"]
  GITHUB_SECRET = ENV["GITHUB_SECRET"]

  def self.active_ship_call(origin_zip,origin_city,origin_state, origin_country,dest_country,dest_state, dest_city, dest_zip)
    url = BASE_URL + "/shipments/"+ "give_prices" + "/?" + "origin_zip=" + "#{origin_zip}" +  "&origin_city=" + "#{origin_city}" + "&origin_state=" + "#{origin_state}" + "&origin_country=" + "#{origin_country}" + "&dest_country=" + "#{dest_country}" + "&dest_state=" + "#{dest_state}" + "&dest_city=" + "#{dest_city}" + "&dest_zip=" + "#{dest_zip}"

    data = HTTParty.get(url)

    # empty_array = better name needed...
    shipments = []
    # "ship_formation"? better name needed...
    # like origin, destination, weight city stae. etc..
    # ship_formation will be the key that holds all the info I seek?

    data.each do |rate|
      #shorten what we call for each specific key.
      shipments << ShippingService::ShippingMethod.new(rate[0], rate[1])
    end
    shipments
  end





end
