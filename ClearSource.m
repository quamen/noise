//
//  CLEAR.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "CLEARSource.h"
#import "FeedEntry.h"
#import "FeedParser.h"

@implementation CLEARSource

- (NSURL *)feedURL {
  return [NSURL URLWithString:FEED_URL];
}

- (void)update {
  NSArray *feedEntries = [feedParser parse];

  for (FeedEntry *feedEntry in feedEntries) {
    NSString *title = [NSString stringWithFormat:@"Trade %@", feedEntry.published];
    [delegate messageReceivedFromSource:self id:feedEntry.id title:title content:feedEntry.title received:(NSDate *)feedEntry.published priority:0 sticky:NO];
  }
}

@end
