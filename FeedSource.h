///
//  FeedSource.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "Source.h"

#define DEFAULT_TIMEOUT 10 // seconds

@interface FeedSource : Source {
@private
  NSTimer *timer;
}

@end
