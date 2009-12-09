//
//  CLEAR.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "FeedSource.h"

#define FEED_URL @"https://app.cleargrain.com.au/trades.atom"

@class FeedParser;

@interface CLEARSource : FeedSource {

}

- (NSURL *)feedURL;

@end
