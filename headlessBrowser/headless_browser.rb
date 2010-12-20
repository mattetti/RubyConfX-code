framework 'Cocoa'
framework 'WebKit'

class HeadlessBrowser
  
  attr_accessor :view, :js_engine, :callback
  
  def initialize
    @view   = WebView.alloc.initWithFrame([0, 0, 520, 520])
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

  # Fetches a url and triggers a callback if available
  # @param [String] url The Url to fetch via the headless browser instance.
  # @return [Nil] Nothing is returned right away, the response comes asynchronously 
  # using the webView callback.
  def fetch(url, &block)
    puts "fetching #{url}"
    page_url = NSURL.URLWithString(url)
    view.mainFrame.loadRequest(NSURLRequest.requestWithURL(page_url))
    if block_given?
      @callback = block
    end
  end
  
  # WebKit Callback method called by the browser when the browser finished to load the
  # page.
  # If a callback was set when fetching, it will be triggered with the browser instance
  # as a param.
  # Careful, this code really isn't really safe, it actually sucks. 
  # Because fetching happens asynchronously changing the callback block while fetching
  # will cause major stomach pain to all people 15 feet around you.
  def webView(view, didFinishLoadForFrame:frame)
    puts "Page loaded"
    @js_engine = view.windowScriptObject
    callback.call(self) if @callback
  end
  
end
