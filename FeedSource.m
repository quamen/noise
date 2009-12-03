//
//  FeedSource.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "FeedSource.h"

@interface FeedSource (Private)

- (void)update;
- (void)startStopTimer;

@end


@implementation FeedSource

- (void)setEnabled:(bool)value {
  [super setEnabled:value];
  [self startStopTimer];
  [self update];
}

- (void)startStopTimer {
  if (timer != nil) {
    [timer invalidate];
    timer = nil;
  }

  if (enabled) {
    timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_TIMEOUT target:self selector:@selector(update) userInfo:nil repeats:YES];
  }
}

- (void)update {
  // Abstract method.
}

@end
