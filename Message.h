//
//  Message.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

@interface Message : NSManagedObject {
  int  priority;
  BOOL sticky;
  BOOL unread;
}

@property (assign) NSString *id;
@property (assign) NSString *source;
@property (assign) NSString *title;
@property (assign) NSString *content;

@property int  priority;
@property BOOL sticky;
@property BOOL unread;

- (void)read;

@end
