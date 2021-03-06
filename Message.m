//
//  Message.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic id, source, title, content, received;

- (void)read {
  [self setUnread:NO];
}

- (int)priority {
  [self willAccessValueForKey:@"priority"];
  int value = priority ;
  [self didAccessValueForKey:@"priority"];
  return value;
}

- (void)setPriority:(int)value {
  [self willChangeValueForKey:@"priority"];
  priority = value;
  [self didChangeValueForKey:@"priority"];
}

- (BOOL)unread {
  [self willAccessValueForKey:@"unread"];
  BOOL value = unread;
  [self didAccessValueForKey:@"unread"];
  return value;
}

- (void)setUnread:(BOOL)value {
  [self willChangeValueForKey:@"unread"];
  unread = value;
  [self didChangeValueForKey:@"unread"];
}

- (BOOL)sticky {
  [self willAccessValueForKey:@"sticky"];
  BOOL value = sticky;
  [self didAccessValueForKey:@"sticky"];
  return value;
}

- (void)setSticky:(BOOL)value {
  [self willChangeValueForKey:@"sticky"];
  sticky = value;
  [self didChangeValueForKey:@"sticky"];
}

- (NSImage *)icon {
	return [NSImage imageNamed:@"NSApplicationIcon"];
}

@end
