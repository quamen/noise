//
//  Source.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "Source.h"
#import "Message.h"

@interface Source (Private)

- (void)contextDidSave:(NSNotification *)notification;
- (BOOL)messageExistsWithID:(NSString *)id;
- (void)saveAction;

@end


@implementation Source

@synthesize managedObjectContext, delegate, enabled;

- (id)initWithDelegate:(id <SourceDelegate>)aDelegate {
  if (self = [super init]) {
    delegate = aDelegate;
    enabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:managedObjectContext];
  }
  return self;
}

- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext) return managedObjectContext;
  NSPersistentStoreCoordinator *coordinator = [delegate persistentStoreCoordinator];
  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator:coordinator];  
  return managedObjectContext;
}

- (NSString *)identifier {
  Class sourceClass = [self class];
  NSBundle *sourceBundle = [NSBundle bundleForClass:sourceClass];
  return [sourceBundle bundleIdentifier];
}

- (void)update {
  NSLog(@"Updating %@ source...", [[self class] description]);
}

- (void)messageReceivedWithID:(NSString *)id title:(NSString *)title content:(NSString *)content received:(NSDate *)received priority:(int)priority sticky:(BOOL)sticky {
  if ([self messageExistsWithID:id]) return;
  
  Message *message = [NSEntityDescription insertNewObjectForEntityForName:MESSAGE_ENTITY_NAME inManagedObjectContext:[self managedObjectContext]];
  
  [message setSource:[self identifier]];
  [message setId:id];
  [message setTitle:title];
  [message setContent:content];
  [message setReceived:received];
  [message setPriority:priority];  
  [message setSticky:sticky];
  
  [self saveAction];
}

#pragma mark -
#pragma mark Private methods

- (void)contextDidSave:(NSNotification *)notification {
  [[delegate managedObjectContext] performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                    withObject:notification
                                                 waitUntilDone:YES];
}

- (BOOL)messageExistsWithID:(NSString *)id {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:MESSAGE_ENTITY_NAME inManagedObjectContext:[self managedObjectContext]]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source == %@ AND id == %@", [self identifier], id];
  [request setPredicate:predicate];
  NSError *error = nil;
  NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
  
  if (error) {
    [NSApp presentError:error];
    return NO;
  }
  
  return [results count] > 0;
}

- (void)saveAction {
  NSError *error = nil;
  
  if (![[self managedObjectContext] commitEditing]) {
    NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
  }
  
  if (![[self managedObjectContext] save:&error]) {
    [[NSApplication sharedApplication] presentError:error];
  }
}

@end
