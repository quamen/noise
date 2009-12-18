//
//  NSBundle+CacheImages.m
//  Noise
//
//  Created by Joshua Bassett on 18/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "NSBundle+CacheImages.h"

@implementation NSBundle(NameCacheImages)

- (void) cacheImages {
  NSArray *types = [NSImage imageFileTypes];
  NSEnumerator *e = [types objectEnumerator];
  NSString *type;

  while ((type = [e nextObject]) != nil) {
    NSArray *files = [self pathsForResourcesOfType:type inDirectory:nil];
    NSEnumerator *e2 = [files objectEnumerator];
    NSString *path;

    while ((path = [e2 nextObject]) != nil) {
      NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
      NSImage *image = [NSImage imageNamed:name];

      if (!image) {
        NSImage *image = [[NSImage alloc] initByReferencingFile:path];

        if (image) {
          [image setName:name];
        }
      }
    }
  }
}

@end
