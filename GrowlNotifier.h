//
//  GrowlNotifier.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import <Growl/Growl.h>
#import "Notifier.h"

#define NOISE_NOTIFICATION @"Noise Notification"

@interface GrowlNotifier : Notifier <GrowlApplicationBridgeDelegate> {

}

@end
