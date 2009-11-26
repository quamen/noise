# feed_parser.rb
# noise
#
# Created by Gareth Townsend on 24/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.

class FeedParser
	def	initialize(feed_url)
		@url = feed_url
		@feed = Feed.new
		@entry = nil
		@element = nil
	end

	def parse
		parser = NSXMLParser.new.initWithContentsOfURL(@url)
		parser.delegate = self;
		parser.parse
		@feed
	end

	ELEMENTS = ['updated', 'title', 'id', 'published', 'content', 'author']

	def parser(parser, didStartElement:elementName, namespaceURI:namespaceURI, qualifiedName:qName, attributes:attributeDict)
	  if elementName == 'feed'
	    @feed.xmlns = attributeDict.objectForKey('xmlns')
		elsif elementName == 'entry'
			@entry = Entry.new
		elsif ELEMENTS.include?(elementName)
			@element = elementName
	  end
	end

	def parser(parser, foundCharacters:string)
    if @element && @entry

			@entry.send("#{@element}=".to_sym, %! #{@entry.send("#{@element}".to_sym)}#{string.strip} !.strip)
		end
	end

	def parser(parser, didEndElement:elementName, namespaceURI:namespaceURI, qualifiedName:qName)
		if elementName == 'entry'
			@feed.entries << @entry
			@entry = nil
		end
		@element = nil if @element
	end

	def parser(parser, parseErrorOccurred:parseError)
		puts parseError.localizedDescription
	end
end
