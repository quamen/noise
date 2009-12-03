//
//  Message.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

@interface Message : NSObject {
@private
  NSString *title;
  NSString *content;
  bool sticky;
  bool unread;
  int priority;
}

@property (readonly, copy) NSString *title;
@property (readonly, copy) NSString *content;
@property (readonly, assign) bool sticky;
@property (readonly, assign) bool unread;
@property (readonly, assign) int priority;

- (id)initWithTitle:(NSString *)aTitle content:(NSString *)theContent sticky:(bool)isSticky;

- (void)read;

@end
