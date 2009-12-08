//
//  GrowlNotifier.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "GrowlNotifier.h"
#import "Message.h"

#define GROWL_FRAMEWORK_FILE_NAME @"Growl.framework"

@implementation GrowlNotifier

- (id)init {
  if (self = [super init]) {
		NSString *privateFrameworksPath = [[NSBundle bundleForClass:[GrowlNotifier class]] privateFrameworksPath];
		NSString *growlBundlePath = [privateFrameworksPath stringByAppendingPathComponent:GROWL_FRAMEWORK_FILE_NAME];
		NSBundle *growlBundle = [NSBundle bundleWithPath:growlBundlePath];
    
		if (growlBundle) {
			if ([growlBundle load]) {
				if ([GrowlApplicationBridge respondsToSelector:@selector(frameworkInfoDictionary)]) {
          [GrowlApplicationBridge setGrowlDelegate:self];
          
					NSDictionary *infoDictionary = [GrowlApplicationBridge frameworkInfoDictionary];
					NSLog(@"Using %@ %@", GROWL_FRAMEWORK_FILE_NAME, [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey]);
        } else {
          NSLog(@"Using a version of %@ older than 1.1", GROWL_FRAMEWORK_FILE_NAME);
        }
      }
    } else {
      NSLog(@"Could not load %@, GrowlNotifier disabled", GROWL_FRAMEWORK_FILE_NAME);
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

#pragma mark GrowlApplicationBridge delegate methods

- (NSString *)applicationNameForGrowl {
  return @"Noise";
}

- (NSImage *)applicationIconForGrowl {
	return [NSImage imageNamed:@"NSApplicationIcon"];
}

- (NSDictionary *)registrationDictionaryForGrowl {
	NSArray *allowedNotifications = [NSArray arrayWithObject:NOISE_NOTIFICATION];
	NSArray *defaultNotifications = [NSArray arrayWithObject:NOISE_NOTIFICATION];
  
	NSDictionary *ticket = [NSDictionary dictionaryWithObjectsAndKeys:
                          allowedNotifications, GROWL_NOTIFICATIONS_ALL,
                          defaultNotifications, GROWL_NOTIFICATIONS_DEFAULT,
                          nil];
  
	return ticket;
}

@end
