framework 'Cocoa'
framework 'WebKit'
require 'headless_browser'

browser = HeadlessBrowser.new
browser.fetch("http://macruby.org") do |b| 
  puts "Fetching MacRuby current version from the website:"
  puts b.js_engine.evaluateWebScript("document.getElementById('current_version').innerHTML" )
  exit
end

# keep the loop running
NSRunLoop.currentRunLoop.runUntilDate(NSDate.distantFuture)