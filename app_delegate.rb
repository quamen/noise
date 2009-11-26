# app_delegate.rb
# noise
#
# Created by Gareth Townsend on 24/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.

require 'time'

class AppDelegate
	attr_accessor :menulet, :noise_growler

  # NSApplicationDelegate methods.
  
  def applicationDidFinishLaunching(notification)
    @noise_growler = NoiseGrowler.new
		clear_growler = CLEARGrowler.new
  end
end

class CLEARGrowler
  
  attr_accessor :feed
  
  def initialize
    @updated = Time.now
		@timer = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector:'do_update', userInfo:nil, repeats:true)
		@timer.fire
  end
	
	def	do_update
	  parse_feed
		growler = NSApplication.sharedApplication.delegate.noise_growler
		
		
		feed.entries.delete_if {|entry| Time.parse(entry.published) <= @updated }
		total = feed.entries.inject(0) {|c,v| c += v.title.match(/\d*[.]\d*/)[0].to_f; c}
		
		if total > 0
			message = "#{total.round} tonnes traded"
			
			growler.notify 'Trade', message
			NSSpeechSynthesizer.new.startSpeakingString(message)
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