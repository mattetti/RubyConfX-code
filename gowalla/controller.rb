# controller.rb
# gowalla
#
# Created by Matt Aimonetti on 10/17/10.
# Copyright 2010 m|a agile. All rights reserved.


class Controller

  attr_accessor :spots, :spot_table

  def applicationDidFinishLaunching(notification)
    @spots = []
    location_manager = LocationManager.new do |new_location, manager|
      puts "location: #{new_location.description}"
      gowalla = gowalla_req(new_location)
      @spots = gowalla['spots'].map{|spot| GowallaSpot.new(spot)}
      @spots.sort!{|a,b| a.radius_meters <=> b.radius_meters}
      spot_table.reloadData
      manager.stop
    end

    spot_table.dataSource = self
    spot_table.doubleAction = "preview:"
    location_manager.start
  end
  
  def windowWillClose(sender)
    exit
  end
  
  def numberOfRowsInTableView(view)
    spots.size
  end
  
  def tableView(view, sortDescriptorsDidChange: descriptors)
    spot_table.reloadData
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    spot = @spots[index]
    name = column.identifier
    case name
    when 'image'
      # NSImageCell instance, we need to feed it a NSImage
      @cell_images ||= {}
      @cell_images[spot.image] ||= NSImage.alloc.initWithData( NSURL.URLWithString(spot.image).resourceDataUsingCache(true) )
    else
      spot.send(column.identifier.to_sym)
    end
  end
  
  def gowalla_req(location)
    http = Net::HTTP.start('api.gowalla.com')
    req = Net::HTTP::Get.new("/spots?lat=#{location.coordinate.latitude}&lng=#{location.coordinate.longitude}&radius=500")
    req.add_field("Accept", "application/json")
    req.add_field("X-Gowalla-API-Key", "d833e71db7d8479ebfedf6985a08f9b3")
    response = http.request(req)
    JSON.parse(response.body)
  end
  
  def preview(sender)
    if spot_table.selectedRow == -1
      alert
    else
      url = @spots[spot_table.selectedRow].url
      NSWorkspace.sharedWorkspace.openURL(url)
    end
  end
  
  def alert(title='Nothing Selected', message='You need to select a row before clicking here.')
    NSAlert.alertWithMessageText(title, 
                                    defaultButton: 'OK',
                                    alternateButton: nil, 
                                    otherButton: 'Cancel',
                                    informativeTextWithFormat: message).runModal
  end

end