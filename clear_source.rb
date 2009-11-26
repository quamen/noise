# Copyright 2009 Active Pathway. All rights reserved.

class CLEARSource
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
      atom_file_path = "https://app.cleargrain.com.au/trades.atom"
      feed_url = NSURL.URLWithString(atom_file_path)
      feed_parser = FeedParser.new(feed_url)
      @feed = feed_parser.parse
    end
end
