//
//  FeedEntry.h
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

@interface FeedEntry : NSObject {
@private
  NSString *id;
  NSString *title;
  NSString *content;
  NSDate   *published;
  NSURL    *link;
}

@property (readwrite, copy) NSString *id;
@property (readwrite, copy) NSString *guid;
@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSString *content;
@property (readwrite, copy) NSDate   *published;
@property (readwrite, copy) NSURL    *link;

@end
