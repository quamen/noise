# Copyright 2009 Active Pathway. All rights reserved.

require 'feed_parser'
require 'time'

class CLEARSource
  FEED_URL = "https://app.cleargrain.com.au/trades.atom"
  POLL_INTERVAL = 10

  attr_accessor :feed

  def initialize(delegate)
    @delegate = delegate
    @updated = Time.now
		@timer = NSTimer.scheduledTimerWithTimeInterval(POLL_INTERVAL, target:self, selector:'do_update', userInfo:nil, repeats:true)
		@timer.fire
  end

	def	do_update
	  parse_feed
    
		feed.entries.delete_if {|entry| Time.parse(entry.published) <= @updated }
		total = feed.entries.inject(0) {|total, value| total += value.title.match(/\d*[.]\d*/)[0].to_f; total }.round(2)

		if total > 0
			message = "#{total} tonnes traded"
			@delegate.notify("Trade", message)
			@updated = Time.parse(feed.entries.first.published)
		end
	end

	private
    def parse_feed
      url = NSURL.URLWithString(FEED_URL)
      feed_parser = FeedParser.new(url)
      @feed = feed_parser.parse
    end
end
