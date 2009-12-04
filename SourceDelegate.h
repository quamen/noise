//
//  SourceDelegate.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

@class Source;

@protocol SourceDelegate

- (void)messageReceivedFromSource:(Source *)source id:(NSString *)id title:(NSString *)title content:(NSString *)content priority:(int)priority sticky:(BOOL)sticky;

@end
