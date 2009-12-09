///
//  FeedSource.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "Source.h"

#define DEFAULT_TIMEOUT 10 // seconds

@class FeedParser;

@interface FeedSource : Source {
@protected
  FeedParser *feedParser;
  NSTimer *timer;
}

- (NSURL *)feedURL;

@end
