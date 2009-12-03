//
//  NoiseAppDelegate.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "NoiseAppDelegate.h"
#import "CLEAR.h"
#import "GrowlNotifier.h"

@interface NoiseAppDelegate (Private)

- (void)loadSources;
- (void)loadNotifiers;

@end


@implementation NoiseAppDelegate

@synthesize window;

- (id)init {
  if (self = [super init]) {
    [self loadSources];
    [self loadNotifiers];
  }
  return self;
}

- (void)loadNotifiers {
  Notifier *notifier = [[GrowlNotifier alloc] init];
  notifiers = [[NSArray alloc] initWithObjects:notifier, nil];
}

- (void)loadSources {
  Source *source = [[CLEAR alloc] init];
  [source setDelegate:self];
  sources = [[NSArray alloc] initWithObjects:source, nil];
}

// NSApplicationDelegate methods.

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  for (Source *source in sources) {
    [source setEnabled:YES];
  }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  for (Source *source in sources) {
    [source setEnabled:NO];
  }
}

// SourceDelegate methods.

- (void)messageReceived:(Message *)message {
  for (Notifier *notifier in notifiers) {
    [notifier notify:message];
  }  
}

@end
