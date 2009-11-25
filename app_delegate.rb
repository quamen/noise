# app_delegate.rb
# noise
#
# Created by Gareth Townsend on 24/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.



class AppDelegate
	attr_accessor :menulet, :noise_growler

  # NSApplicationDelegate methods.
  
  def applicationDidFinishLaunching(notification)
    noise_growler = NoiseGrowler.new
		
		atom_file_path = "http://app.cleargrain.com.au/trades.atom"
		feed_url = NSURL.URLWithString(atom_file_path)
		feed_parser = FeedParser.new(feed_url)
		feed = feed_parser.parse
		
		feed.entries.each do |entry|
			noise_growler.notify 'Trade', entry.content.gsub(/<\/?[^>]*>/, "")
		end
		
		NSSpeechSynthesizer.new.startSpeakingString("#{feed.entries.count} new trades")
  end
end