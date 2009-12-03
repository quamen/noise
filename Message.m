//
//  Message.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize title, content, sticky, unread, priority;

- (id)init {
  if (self = [super init]) {
    unread = true;
    priority = 0;
  }
  return self;
}


- (id)initWithTitle:(NSString *)aTitle content:(NSString *)theContent sticky:(bool)isSticky {
  if (self = [self init]) {
    title = aTitle;
    content = theContent;
    sticky = isSticky;
  }
  return self;
}

- (void)read {
  unread = NO;
}

@end
