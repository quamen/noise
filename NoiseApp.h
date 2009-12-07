//
//  NoiseAppDelegate.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "SourceDelegate.h"

@interface NoiseApp : NSObject <NSApplicationDelegate, SourceDelegate> {
@private
  NSWindow *window;

  NSMutableArray *sources;
  NSMutableArray *notifiers;
  
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
  NSManagedObjectModel         *managedObjectModel;
  NSManagedObjectContext       *managedObjectContext;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
