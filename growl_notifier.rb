# Copyright 2009 Clear Interactive. All rights reserved.

require 'notifier'

class GrowlNotifier < Notifier
  APP_NAME = "Noise"
  NOTIFICATION_NAME = "Noise Notification"

  attr_accessor :ready

  def initialize
    initalize_growl
    super
  end

  def notify(title, message)
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

  # GrowlApplicationBridgeDelegate methods.

  def growlIsReady
    @growl_is_ready = true
  end

  def applicationNameForGrowl
    APP_NAME
  end

  private
    def initalize_growl
      @growl_is_ready = false
      GrowlApplicationBridge.setGrowlDelegate(self);
    end
end
