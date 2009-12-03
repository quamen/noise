//
//  CLEAR.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "CLEAR.h"

@implementation CLEAR

- (id)init {
  if (self = [super init]) {
    NSURL *url = [NSURL URLWithString:FEED_URL];
    feedParser = [[FeedParser alloc] initWithUrl:url];
  }
  return self;
}

- (void)update {
  NSArray *feedEntries = [feedParser parse];

  for (FeedEntry *feedEntry in feedEntries) {
    Message *message = [[Message alloc] initWithTitle:@"Trade" content:feedEntry.title sticky:NO];
    [self messageReceived:message];
  }
}

@end
