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

  def notify_growl(message)
    #return unless @growl_is_ready
    
    GrowlApplicationBridge.notifyWithTitle(
      APP_NAME,
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
    notify_growl "You suck!"
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
