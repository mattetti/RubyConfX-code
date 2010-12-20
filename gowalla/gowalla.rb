# gowalla.rb
# gowalla
#
# Created by Matt Aimonetti on 10/17/10.
# Copyright 2010 m|a agile. All rights reserved.

require 'net/http'
require 'json'

module Gowalla

  def self.spots(location)
    http = Net::HTTP.start('api.gowalla.com')
    req = Net::HTTP::Get.new("/spots?lat=#{location.coordinate.latitude}&lng=#{location.coordinate.longitude}&radius=500")
    req.add_field("Accept", "application/json")
    req.add_field("X-Gowalla-API-Key", "d833e71db7d8479ebfedf6985a08f9b3")
    response = http.request(req)
    JSON.parse(response.body)
  end

end
