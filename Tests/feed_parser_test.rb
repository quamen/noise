# feed_parser_test.rb
# noise
#
# Created by Gareth Townsend on 24/11/09.
# Copyright 2009 Clear Interactive. All rights reserved.

require 'test/unit'
require 'feed_parser.rb'

class AtomFeedParserTest < Test::Unit::TestCase

  def setup
		feed_url = NSURL.fileURLWithPath(File.expand_path(File.dirname(__FILE__) + "/atom.xml"))
		@atom_feed_parser = FeedParser.new(feed_url)
  end
  
  def teardown
    @atom_feed_parser = nil
  end
	
	def test_feed_xmlns_set
		feed = @atom_feed_parser.parse
		assert_equal('http://www.w3.org/2005/Atom', feed.xmlns)
	end
	
	def test_feed_type_set
		feed = @atom_feed_parser.parse
		assert_equal('atom', feed.type)
	end
	
	def test_feed_number_of_entries
		feed = @atom_feed_parser.parse
		assert_equal(22, feed.entries.count)
	end
	
	FeedParser::ELEMENTS.each do |element|
	  class_eval do
	    define_method "test_feed_entry_#{element}_set" do
    		feed = @atom_feed_parser.parse
    		feed.entries.each do |entry|
    			assert_not_nil(entry.send("#{element}".to_sym))
    		end
    	end
    end
  end
end