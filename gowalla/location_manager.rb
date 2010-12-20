# location_manager.rb
# gowalla
#
# Created by Matt Aimonetti on 10/17/10.
# Copyright 2010 m|a agile. All rights reserved.

framework 'CoreLocation'

# CLLocationManager wrapper
# more info on the CoreLocation:
# http://developer.apple.com/library/ios/#documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html
class LocationManager
    
  def initialize(&block)
    @loc          = CLLocationManager.alloc.init
    @loc.delegate = self
    @callback     = block
  end
  
  def start
    @loc.startUpdatingLocation
  end
  
  def stop
    @loc.stopUpdatingLocation
  end
  
  # Dispatch the CLLocationManager callback to the Ruby callback
  def locationManager(manager, didUpdateToLocation: new_location, fromLocation: old_location)
    @callback.call(new_location, self)
  end
  
end