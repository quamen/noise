//
//  FeedParser.m
//  Noise
//
//  Created by Joshua Bassett on 2/12/09.
//  Copyright 2009 Active Pathway. All rights reserved.
//

#import <objc/runtime.h>
#import "ISO8601DateFormatter.h"
#import "FeedEntry.h"
#import "FeedParser.h"
#import "NSString+InflectionSupport.h"

@interface FeedParser (Private)

+ (Class)getPropertyClass:(Class)source property:(NSString *)propertyName;
+ (NSDate *)parseDate:(NSString *)dateString;

@end


@implementation FeedParser

- (id)initWithUrl:(NSURL *)aUrl {
  if (self = [self init]) {
    url = aUrl;
    properties = [NSSet setWithObjects:@"id", @"title", @"content", @"published", nil];
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

+ (NSDate *)parseDate:(NSString *)dateString {  
  ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
  return [formatter dateFromString:dateString];
}

+ (Class)getPropertyClass:(Class)source property:(NSString *)propertyName {
  objc_property_t property = class_getProperty([source class], [propertyName UTF8String]);
  NSString *propertyAttributesString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
  NSArray *propertyAttributes = [propertyAttributesString componentsSeparatedByString:@","];
  NSString *propertyClassName = [propertyAttributes objectAtIndex:0];
  propertyClassName = [propertyClassName substringWithRange:NSMakeRange(3, [propertyClassName length] - 4)];
  return NSClassFromString(propertyClassName);
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName {
  if ([elementName isEqualToString:@"entry"]) {
    [entries addObject:currentEntry];
    currentEntry = nil;
  } else if (currentEntry != nil && [properties containsObject:elementName]) {
    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [elementName titleize]]);
    Class klass = [FeedParser getPropertyClass:[currentEntry class] property:elementName];

    if ([currentEntry respondsToSelector:setter]) {
      if (klass == [NSDate class]) {
        [currentEntry performSelector:setter withObject:[FeedParser parseDate:currentText]];
      } else {
        [currentEntry performSelector:setter withObject:currentText];
      }
    }
  }

  currentText = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

}

@end
