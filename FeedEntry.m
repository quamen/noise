//
//  FeedEntry.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "FeedEntry.h"

@implementation FeedEntry

@synthesize id, title, content, published;

- (void)setGuid:(NSString *)guid {
  [self setId:[guid copy]];
}

- (NSString *)guid {
  return [self id];
}

@end
