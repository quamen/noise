//
//  Message.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Message : NSManagedObject {
  int  priority;
  BOOL sticky;
  BOOL unread;
}

@property (assign) NSString *id;
@property (assign) NSString *source;
@property (assign) NSString *title;
@property (assign) NSString *content;
@property (assign) NSDate *received;
@property (readonly, assign) NSImage *icon;

@property int  priority;
@property BOOL sticky;
@property BOOL unread;

- (void)read;

@end
