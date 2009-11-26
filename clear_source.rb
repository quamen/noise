# Copyright 2009 Active Pathway. All rights reserved.

require 'feed_parser'
require 'time'

class CLEARSource
  FEED_URL = "http://localhost:3000/trades.atom"
  POLL_INTERVAL = 10

  attr_accessor :feed

  def initialize(delegate)
		register_defaults
    @delegate = delegate
		@timer = NSTimer.scheduledTimerWithTimeInterval(POLL_INTERVAL, target:self, selector:'do_update', userInfo:nil, repeats:true)
		@timer.fire
  end

	def	do_update
	  parse_feed
    
		feed.entries.delete_if {|entry| Time.parse(entry.published) <= Time.parse(NSUserDefaults.standardUserDefaults.stringForKey('clear_updated')) }
		total = feed.entries.inject(0) {|total, value| total += value.title.match(/\d*[.]\d*/)[0].to_f; total }.round(2)

		if total > 0
			message = "#{total} tonnes traded"
			@delegate.notify("Trade", message)
			
			NSUserDefaults.standardUserDefaults.setObject(feed.entries.first.published, forKey:'clear_updated')
		end
	end

	private
    def parse_feed
      url = NSURL.URLWithString(FEED_URL)
      feed_parser = FeedParser.new(url)
      @feed = feed_parser.parse
    end
		
		def register_defaults
			defaults = NSUserDefaults.standardUserDefaults
			appDefaults = NSDictionary.dictionaryWithObject(Time.now.to_s, forKey:'clear_updated')
			defaults.registerDefaults(appDefaults)
		end
end
