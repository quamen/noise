//
//  FeedParser.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

@class FeedEntry;

@interface FeedParser : NSObject <NSXMLParserDelegate> {
@private
  NSURL          *url;
  NSMutableArray *entries;
  NSSet          *properties;
  FeedEntry      *currentEntry;
  NSString       *currentProperty;
  NSString       *currentText;
}

- (id)initWithUrl:(NSURL *)aUrl;

- (NSArray *)parse;

@end
