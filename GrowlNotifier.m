//
//  GrowlNotifier.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "GrowlNotifier.h"
#import "Message.h"


@interface GrowlNotifier (Private)

- (void)initGrowl;
- (void)growlMessage:(Message *)message;

@end


@implementation GrowlNotifier

- (id)init {
  if (self = [super init]) {
    growlAllowance = GROWLS_PER_PERIOD;
    [self initGrowl];
  }
  return self;
}

- (void)notify:(Message *)message {
  double timeSinceLastNotify = [lastGrowl timeIntervalSinceNow];
  growlAllowance += timeSinceLastNotify * (GROWLS_PER_PERIOD / PERIOD);
  lastGrowl = [NSDate date];

  if (growlAllowance > GROWLS_PER_PERIOD) {
    growlAllowance = GROWLS_PER_PERIOD; // throttle
  }

  if (growlAllowance <= 0) {
    NSLog(@"Rate limit exceeded, discarding message");
  } else {
    [self growlMessage:message];
  }

  growlAllowance -= 1.0;
}

#pragma mark -
#pragma mark GrowlApplicationBridge methods

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

#pragma mark -
#pragma mark Private methods

- (void)initGrowl {
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

- (void)growlMessage:(Message *)message {
  [GrowlApplicationBridge notifyWithTitle:message.title
                              description:message.content
                         notificationName:@"Noise Notification"
                                 iconData:nil
                                 priority:message.priority
                                 isSticky:message.sticky
                             clickContext:nil];
}

@end
