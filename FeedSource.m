//
//  FeedSource.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "FeedSource.h"
#import "FeedParser.h"

@interface FeedSource (Private)

- (void)startStopTimer;
- (void)timerFired:(NSTimer*)timer;

@end


@implementation FeedSource

- (id)initWithDelegate:(id <SourceDelegate>)aDelegate {
  if (self = [super initWithDelegate:aDelegate]) {
    feedParser = [[FeedParser alloc] initWithUrl:[self feedURL]];
  }
  return self;
}

- (void)setEnabled:(bool)value {
  [super setEnabled:value];
  [self startStopTimer];
}

- (NSURL *)feedURL {
  // Abstract method.
  return nil;
}

#pragma mark -
#pragma mark Private methods

- (void)startStopTimer {
  if (timer != nil) {
    [timer invalidate];
    timer = nil;
  }
  
  if (enabled) {
    timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_TIMEOUT target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    // Fire the timer straight away.
    [timer fire];
  }
}

- (void)timerFired:(NSTimer*)timer {
  [delegate updateSource:self];
}

@end
