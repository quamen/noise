//
//  SourceDelegate.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "Message.h"

@protocol SourceDelegate

- (void)messageReceived:(Message *)message;

@end
