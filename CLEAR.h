//
//  CLEAR.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "FeedSource.h"
#import "FeedParser.h"

#define FEED_URL @"http://app.cleargrain.com.au/trades.atom"

@interface CLEAR : FeedSource {
@private
  FeedParser *feedParser;
}

@end
