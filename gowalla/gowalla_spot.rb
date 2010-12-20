# GowallaSpot.rb
# gowalla
#
# Created by Matt Aimonetti on 10/17/10.
# Copyright 2010 m|a agile. All rights reserved.


class GowallaSpot

  attr_reader :name
  attr_reader :url
  attr_reader :description
  attr_reader :highlights_url
  attr_reader :lat, :lgn
  attr_reader :image
  attr_reader :items_count
  attr_reader :radius_meters
  attr_reader :users, :checkins
  

  # {"highlights_url"=>"/spots/846618/highlights", "lat"=>32.9580309077, "_image_url_200"=>"http://static.gowalla.com/categories/102-9688a32c2ffb131a9f38598f17aa6047-200.png?1", "_image_url_50"=>"http://static.gowalla.com/categories/102-02a481cfcee8bb7b91363d7acc986b76-100.png?1", "items_count"=>0, "radius_meters"=>100, "lng"=>-117.1221600254, "url"=>"/spots/846618", "description"=>nil, "checkins_url"=>"/checkins?spot_id=846618", "spot_categories"=>[{"url"=>"/categories/102", "name"=>"Library"}], "address"=>{"locality"=>"San Diego", "region"=>"CA"}, "strict_radius"=>false, "trending_level"=>0, "users_count"=>8, "activity_url"=>"/spots/846618/events", "checkins_count"=>8, "image_url"=>"http://static.gowalla.com/categories/102-02a481cfcee8bb7b91363d7acc986b76-100.png?1", "items_url"=>"/spots/846618/items", "photos_count"=>1, "name"=>"San Diego Public Library Rancho Penasquitos Branch"}, {"highlights_url"=>"/spots/1334017/highlights", "lat"=>32.958517683, "_image_url_200"=>"http://static.gowalla.com/categories/185-52081907a5e9f8f4bf196929a18535af-200.png?1", "_image_url_50"=>"http://static.gowalla.com/categories/185-ab56061ce34473f8216fb43ed8b1d1bc-100.png?1", "items_count"=>1, "radius_meters"=>100, "lng"=>-117.118150967, "url"=>"/spots/1334017", "description"=>nil, "checkins_url"=>"/checkins?spot_id=1334017", "spot_categories"=>[{"url"=>"/categories/185", "name"=>"Castle"}], "address"=>{"locality"=>"San Diego", "region"=>"CA"}, "strict_radius"=>false, "trending_level"=>0, "users_count"=>6, "activity_url"=>"/spots/1334017/events", "checkins_count"=>6, "image_url"=>"http://static.gowalla.com/categories/185-ab56061ce34473f8216fb43ed8b1d1bc-100.png?1", "items_url"=>"/spots/1334017/items", "photos_count"=>0, "name"=>"Notch8 Intergalactic"}
  def initialize(spot_hash)
    @name = spot_hash['name']
    @url = NSURL.URLWithString("http://gowalla.com#{spot_hash['url']}")
    @description = spot_hash['description']
    @highlights_url = 'http://gowalla.com' + spot_hash['highlights_url']
    @lat = spot_hash['lat']
    @lgn = spot_hash['lgn']
    @image = spot_hash['_image_url_50']
    @items_count = spot_hash['items_count']
    @radius_meters = spot_hash['radius_meters']
    @users = spot_hash['users_count']
    @checkins = spot_hash['checkins_count']
  end
  
  
end