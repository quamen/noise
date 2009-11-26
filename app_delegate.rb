# Copyright 2009 Clear Interactive. All rights reserved.

require 'growl_notifier'
require 'speech_notifier'
require 'clear_source'

class AppDelegate
	attr_accessor :menulet

  def initialize
    @notifiers = []
  end

  def notify(title, message)
    @notifiers.each {|notifier| notifier.notify(title, message) }
  end

  # NSApplicationDelegate methods.

  def applicationDidFinishLaunching(notification)
    @notifiers << GrowlNotifier.new
		@notifiers << SpeechNotifier.new
    @clear = CLEARSource.new(self)
  end
	
	private
end
