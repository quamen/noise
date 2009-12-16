//
//  Source.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "SourceDelegate.h"

@interface Source : NSObject {
@protected
  id <SourceDelegate> delegate;
  bool enabled;

  NSManagedObjectContext *managedObjectContext;
}

@property (readwrite, assign) id <SourceDelegate> delegate;
@property (readwrite, assign) bool enabled;
@property (readonly) NSString *name;
@property (readonly) NSString *fullName;
@property (readonly) NSImage *icon;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithDelegate:(id <SourceDelegate>)aDelegate;

- (void)update;

- (void)messageReceivedWithID:(NSString *)id
                        title:(NSString *)title
                      content:(NSString *)content
                     received:(NSDate *)received
                     priority:(int)priority
                       sticky:(BOOL)sticky;

@end
