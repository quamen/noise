//
//  GrowlNotifier.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "Notifier.h"

#define GROWL_FRAMEWORK_FILE_NAME @"Growl.framework"
#define NOISE_NOTIFICATION @"Noise Notification"

// Growl rate limiting.
#define GROWLS_PER_PERIOD 5
#define PERIOD 5 // seconds

@interface GrowlNotifier : Notifier <GrowlApplicationBridgeDelegate> {
@private
  double growlAllowance;
  NSDate *lastGrowl;
}

@end
