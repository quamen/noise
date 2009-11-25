# noise_growler.rb
# noise
#
# Created by Gareth Townsend on 26/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.

class NoiseGrowler
  APP_NAME = "Noise"
  NOTIFICATION_NAME = "Noise Notification"

  attr_accessor :ready

  def initialize
    initalize_growl
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