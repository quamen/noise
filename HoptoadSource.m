//
//  HoptoadSource.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "HoptoadSource.h"
#import "FeedEntry.h"
#import "FeedParser.h"

@implementation HoptoadSource

- (NSString *)name {
  return @"Hoptoad";
}

- (NSURL *)feedURL {
  return [NSURL URLWithString:FEED_URL];
}

- (NSImage *)icon {
	return [NSImage imageNamed:@"hoptoad.png"];
}

- (void)update {
  [super update];

  NSArray *feedEntries = [feedParser parse];

  for (FeedEntry *feedEntry in feedEntries) {
    NSString *title = [NSString stringWithFormat:@"Error %@", feedEntry.published];
    
    [self messageReceivedWithID:feedEntry.id
                          title:title
                        content:feedEntry.title
                       received:(NSDate *)feedEntry.published
                       priority:NOISE_MESSAGE_PRIORITY_NORMAL
                         sticky:NO];
  }
}

@end
