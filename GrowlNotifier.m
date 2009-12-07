//
//  GrowlNotifier.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "GrowlNotifier.h"
#import "Message.h"

@implementation GrowlNotifier

- (id)init {
  if (self = [super init]) {
		NSString *privateFrameworksPath = [[NSBundle bundleForClass:[self class]] privateFrameworksPath];
		NSString *growlBundlePath = [privateFrameworksPath stringByAppendingPathComponent:@"Growl.framework"];
		NSBundle *growlBundle = [NSBundle bundleWithPath:growlBundlePath];
    
		if (growlBundle) {
			if ([growlBundle load]) {
        [GrowlApplicationBridge setGrowlDelegate:self];
      }
    } else {
      NSLog(@"Could not load Growl.framework, GrowlNotifier disabled");
    }
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
