//
//  NoiseAppDelegate.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "SourceDelegate.h"

@interface NoiseAppDelegate : NSObject <NSApplicationDelegate, SourceDelegate> {
@private
  NSWindow *window;
  NSArray *sources;
  NSArray *notifiers;
}

@property (assign) IBOutlet NSWindow *window;

@end
