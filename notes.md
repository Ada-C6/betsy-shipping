Notes from Co-Working on Petsy & API


<ActiveShipping::package:0x007fa352963f28

 - @currency=nil,
 - @cylinder=false,
 - @dimensions=
  [#<Quantified::Length: 4.5 inches>,
   #<Quantified::Length: 10 inches>,
   #<Quantified::Length: 15 inches>],
 - @dimensions_unit_system=:imperial,
 - @gift=false,
 - @options={:units=>:imperial},
 - @oversized=false,
- @unpackaged=false,
- @value=nil,
- @weight=#<Quantified::Mass: 120.0 ounces>,
- @weight_unit_system=:imperial>]

packages =
origin =
destination =


ups = ActiveShipping::Ups.new(login: "", password: "secret", key: "")
response = ups.find_rates(origin, destination, packages)




<!-- => [#<ActiveShipping::package:0x007fa352963f28 @options={:units=>:imperial},
@dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>,
#<Quantified::Length: 15 inches>],
@weight_unit_system=:imperial,
@dimensions_unit_system=:imperial,
@weight=#<Quantified::Mass: 120.0 ounces>,
@value=nil,
@currency=nil,
@cylinder=false,
@gift=false,
@oversized=false,
@unpackaged=false>] -->




2. Goal with API Client is to write something that will transform the results from teh API server into shippping method objects. ()


3.   def self.build_shipment(shipment)
    # will this be some sort of loop to go through the things that will be in destination: city, state, zip, country:
    # destination = Location.new(
    #   :country => 'US',
    #   :state => 'AZ',
    #   :city => 'Phoenix',
    #   :zip => '85020'
    destination = shipment["destination"]

    # I believe this will be a default weight, tht we create in API.
    #   Package.new(
    #   (7.5 * 16),          # 7.5 lbs, times 16 oz/lb.
    #   [15, 10, 4.5],       # 15x10x4.5 inches DIMENSIONS fixed
    #   :units => :imperial) # US style.
    # ]
    weight = shipment["weight"]

    # should this be a loop to get: city, state, zip, country.
    # in this case for now. We will be shipping from Seattle
    # so it will be Seattle, WA,
    # origin = Location.new(
    # :country => 'US',
    # :state => 'WA',
    # :city => 'Seattle',
    # :zip => '98161'
    origin = shipment["origin"]

    packages = shipment["packages"]

    shipment.new(destination, weight, origin, packages)


  end

4.   # # no idea if this is proper language.
  # def self.get_price(package)
  #   url = BASE_URL + "search" + "?r=#{??}"
  #                                       #do I need first?
  #   package = HTTParty.get(url).parsed_response.first
  #   build_shipment(package)
  # end

5.     ups = rate[0][0]
    ups_cost = rate[0][1]

    ups_three_day = rate[1][0]
    ups_three_day_cost = rate[1][1]

    ups_second_day_air = rate[2][0]
    ups_second_day_air_cost = rate[2][1]

    ups_next_day_air_saver = rate[3][0]
    ups_next_day_air_save_cost = rate[3][1]

    ups_next_day_air = rate[4][0]
    ups_next_day_air = rate[4][1]

    ups_next_day_air_early_am = rate[5][0]
    ups_next_day_air_early_am = rate[5][1]

    
