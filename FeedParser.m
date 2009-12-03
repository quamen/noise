//
//  FeedParser.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import "FeedParser.h"
#import "NSString+InflectionSupport.h"

@implementation FeedParser

- (id)initWithUrl:(NSURL *)aUrl {
  if (self = [self init]) {
    url = aUrl;
    properties = [NSSet setWithObjects:@"id", @"title", @"content", nil];
  }
  return self;
}

- (NSArray *)parse {
  entries = [NSMutableArray array];

  NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
  [parser setDelegate:self];
  [parser setShouldProcessNamespaces:NO];
  [parser setShouldReportNamespacePrefixes:NO];
  [parser setShouldResolveExternalEntities:NO];
  [parser parse];

  return entries;
}

// NSXMLParserDelegate methods.

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
  currentText = [[NSString alloc] init];

  if ([elementName isEqualToString:@"entry"]) {
    currentEntry = [[FeedEntry alloc] init];
  } else if ([properties containsObject:elementName]) {
    currentProperty = [elementName copy];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  currentText = [currentText stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName {
  if ([elementName isEqualToString:@"entry"]) {
    [entries addObject:currentEntry];
    currentEntry = nil;
  } else if (currentEntry != nil && [properties containsObject:elementName]) {
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [elementName titleize]]);

    if ([currentEntry respondsToSelector:sel]) {
      [currentEntry performSelector:sel withObject:currentText];
    }
  }

  currentText = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

}

@end
