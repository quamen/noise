//
//  Source.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "Source.h"

@implementation Source

@synthesize enabled, delegate;

- (id)init {
  if (self = [super init]) {
    enabled = YES;
  }
  return self;
}

- (NSString *)identifier {
  Class sourceClass = [self class];
  NSBundle *sourceBundle = [NSBundle bundleForClass:sourceClass];
  return [NSString stringWithFormat:@"%@.%@", [sourceBundle bundleIdentifier], [sourceClass description]];
}

@end
