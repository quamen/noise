# app_delegate.rb
# noise
#
# Created by Gareth Townsend on 24/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.

APP_NAME = "Noise"
NOTIFICATION_NAME = "Noise Notification"

class AppDelegate
	attr_accessor :menulet

  def init
    @growl_is_ready = false
    super
  end

  def notify_growl(title, message)
    #return unless @growl_is_ready
    
    GrowlApplicationBridge.notifyWithTitle(
      title,
      :description      => message,
      :notificationName => NOTIFICATION_NAME,
      :iconData         => nil,
      :priority         => 0,
      :isSticky         => false,
      :clickContext     => nil
    )
  end

  # NSApplicationDelegate methods.
  
  def applicationDidFinishLaunching(notification)
    init_growl
		
		atom_file_path = "http://app.cleargrain.com.au/trades.atom"
		feed_url = NSURL.URLWithString(atom_file_path)
		feed_parser = FeedParser.new(feed_url)
		feed = feed_parser.parse
		
		feed.entries.each do |entry|
			notify_growl 'Trade', entry.content.gsub(/<\/?[^>]*>/, "")
		end
		
		#NSSpeechSynthesizer.new.startSpeakingString("#{feed.entries.count} new trades")
  end
  
  # GrowlApplicationBridgeDelegate methods.
  
  def growlIsReady
    NSLog "Growl ready"
    @growl_is_ready = true
  end
  
  def applicationNameForGrowl
    APP_NAME
  end
  
  private
    def init_growl
      @growl_is_ready = false
      GrowlApplicationBridge.setGrowlDelegate(self);
    end
end
