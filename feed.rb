# feed.rb
# noise
#
# Created by Gareth Townsend on 25/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.

class Feed
	attr_accessor :xmlns, :entries
	attr_reader :type
	
	def xmlns=(value)
	  @type = 'atom' if value == 'http://www.w3.org/2005/Atom'
	  @xmlns = value
		@entries = []
	end
end

class Entry
	attr_accessor :updated, :title
end