//
//  HoptoadSource.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FeedSource.h"
#import "NoiseDefines.h"

#define FEED_URL @"http://clearinteractive.hoptoadapp.com/errors.atom?auth_token=fbafe434bcf3e9feba6e89f6fdb4d55c0e300c7d"

@class FeedParser;

@interface HoptoadSource : FeedSource {

}

- (NSURL *)feedURL;

@end
