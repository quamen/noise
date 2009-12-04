//
//  Source.h
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "SourceDelegate.h"

@interface Source : NSObject {
@protected
  id <SourceDelegate> delegate;
  bool enabled;
}

@property (readwrite, assign) id <SourceDelegate> delegate;
@property (readwrite, assign) bool enabled;

- (NSString *)identifier;

@end
