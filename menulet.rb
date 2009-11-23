# menulet.rb
# noise
#
# Created by Gareth Townsend on 24/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.


class Menulet

	attr_accessor :theMenu
	
	def awakeFromNib
	  @statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
	  @statusItem.setHighlightMode(true)
	  @statusItem.setEnabled(true)
	  @statusItem.setToolTip("Menulet")
	  @statusItem.setMenu(theMenu)
	  
	  bundle = NSBundle.bundleForClass(self.class)
	  path = bundle.pathForImageResource("MenuIcon")
	  menuIcon = NSImage.new.initWithContentsOfFile(path)
	  @statusItem.setTitle("Title")
	  @statusItem.setImage(menuIcon)
	end
	
end