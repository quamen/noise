//
//  GrowlNotifier.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "GrowlNotifier.h"

@implementation GrowlNotifier

- (id)init {
  if (self = [super init]) {
    [GrowlApplicationBridge setGrowlDelegate:self];
  }
  return self;
}

- (void)notify:(Message *)message {
	[GrowlApplicationBridge notifyWithTitle:message.title
                              description:message.content
                         notificationName:@"Noise Notification"
                                 iconData:nil
                                 priority:message.priority
                                 isSticky:message.sticky
                             clickContext:nil];
}

@end
