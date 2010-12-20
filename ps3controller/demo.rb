framework 'Cocoa'
framework File.expand_path("PS3Controller.framework")
framework 'WebKit'

class ControllerDelegate

  attr_reader :controller
  attr_accessor :js

  def initialize
    @controller = PS3SixAxis.sixAixisControllerWithDelegate(self)
  end
  
  def js_call(code)
    js.evaluateWebScript(code) unless js.nil?
  end
  
  def connect
    puts "Connecting to the PS3 controller"
  	controller.connect(true)
  end

  def onDeviceConnectionError(error_code)
    "puts error: #{error_code}"
  end

  def onDeviceConnected
    puts "connected!"
  end

  def onDeviceDisconnected
    puts "Disconnected!"
  end

  # shape buttons

  def onTriangleButton(pressed)
    js_call "debug('Triangle #{pressed ? 'pressed' : 'released'}')"
    js_call "triangle()" if pressed
  end
  
  def onCircleButton(pressed)
    js_call "debug('Circle #{pressed ? 'pressed' : 'released'}')"
    js_call "circle()" if pressed
  end
  
  def onCrossButton(pressed)
    js_call "debug('Cross #{pressed ? 'pressed' : 'released'}')"    
    js_call "cross()" if pressed
  end
  
  def onSquareButton(pressed)
    js_call "debug('Square #{pressed ? 'pressed' : 'released'}')"
    js_call "square()" if pressed
  end
  
  def onL1Button(pressed)
    js_call "debug('L1 #{pressed ? 'pressed' : 'released'}')"
    js_call "l1()" if pressed
  end
  
  def onL2Button(pressed)
    js_call "debug('L2 #{pressed ? 'pressed' : 'released'}')"
    js_call "l2()" if pressed
  end
  
  def onR1Button(pressed)
    js_call "debug('R1 #{pressed ? 'pressed' : 'released'}')"
    js_call "r1()" if pressed
  end
  
  def onR2Button(pressed)
    js_call "debug('R2 #{pressed ? 'pressed' : 'released'}')"
    js_call "r2()" if pressed
  end
  
  # D-PAD
  def onNorthButton(pressed)
    js_call "debug('↑ #{pressed ? 'pressed' : 'released'}')"
    js_call "up()" if pressed 
  end
  def onWestButton(pressed)
    js_call "debug('← #{pressed ? 'pressed' : 'released'}')"
    js_call "left()" if pressed
  end
  def onSouthButton(pressed)
    js_call "debug('↓ #{pressed ? 'pressed' : 'released'}')"
    js_call "down()" if pressed
  end
  def onEastButton(pressed)
    js_call "debug('→ #{pressed ? 'pressed' : 'released'}')"
    js_call "right()" if pressed
  end
  
  # Central buttons
  def onStartButton(pressed)
    @controller.disconnect if pressed
  	exit
  end

  def onPSButton(pressed)
    js_call "ps()" if pressed
  end

  # Axis
  
  #   # Purpose  Note
  # # accX / sin(roll)   On my sixaxis, +11 is rest, +126 is 90deg left, -100 is 90deg right
  # # accY / sin(pitch)  On my sixaxis, -19 is rest, -117 is 90deg nose down, +114 is 90deg, controls facing you
  # # accZ / gravity   On my sixaxis, sat on the table is -93, upside down is 131
  # #
  #   def onAxisX(x, Y:y, Z:z)
  #     js_call "orientation('Orientation: Axis x:#{x} y:#{y} z:#{z}')"
  #   end

  def onLeftStick(axis, pressed:pressed)
    js_call "leftJoystick(#{axis.x}, #{axis.y})"
    js_call "leftJoystickPressed(#{pressed})"
  end

  def onRightStick(axis, pressed:pressed)
    js_call "rightJoystick(#{axis.x}, #{axis.y})"
    js_call "rightJoystickPressed(#{pressed})"
  end

end

class Browser
  
  attr_accessor :view, :js_engine, :controller
  
  def initialize(controller)
    @controller = controller
    @view       = WebView.alloc.initWithFrame([0, 0, 520, 520])
    @window     = NSWindow.alloc.initWithContentRect([200, 200, 520, 520],
                                                styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask, 
                                                backing:NSBackingStoreBuffered, 
                                                defer:false)

    @window.contentView = view
    # Use the screen stylesheet, rather than the print one.
    view.mediaStyle = 'screen'
    view.customUserAgent = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10'
    # Make sure we don't save any of the prefs that we change.
    view.preferences.autosaves = false
    # Set some useful options.
    view.preferences.shouldPrintBackgrounds = true
    view.preferences.javaScriptCanOpenWindowsAutomatically = false
    view.preferences.allowsAnimatedImages = false
    # Make sure we don't get a scroll bar.
    view.mainFrame.frameView.allowsScrolling = false
    view.frameLoadDelegate = self
  end

  def fetch
    page_url = NSURL.alloc.initFileURLWithPath(File.expand_path("index.html"))
    view.mainFrame.loadRequest NSURLRequest.requestWithURL(page_url)
    puts "fetching"
  end
  
  def webView(view, didFinishLoadForFrame:frame)
    puts "page loaded"
    puts "Controller ready to draw!"
    @window.display
    @window.orderFrontRegardless
    
    @js_engine = view.windowScriptObject # windowScriptObject
    @controller.js = @js_engine
    
    @js_engine.setValue(@animal, forKey: "animal")
  end

  def webView(view, didFailLoadWithError:error, forFrame:frame)
    puts "Failed: #{error.localizedDescription}"
  end

  def webView(view, didFailProvisionalLoadWithError:error, forFrame:frame)
    puts "Failed: #{error.localizedDescription}"
  end
  
end

controller = ControllerDelegate.new
controller.connect
browser = Browser.new(controller)
browser.fetch

NSRunLoop.currentRunLoop.runUntilDate(NSDate.distantFuture)