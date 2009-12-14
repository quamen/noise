//
//  AppDelegate.m
//  Noise
//
//  Created by Joshua Bassett on 1/12/09.
//  Copyright 2009 CLEAR Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "Message.h"
#import "Notifier.h"
#import "Source.h"

@interface AppDelegate (Private)

- (void)registerDefaults;
- (void)contextDidSave:(NSNotification *)notification;
- (void)messageReceived:(Message *)message;
- (void)loadSources;
- (void)loadNotifiers;
- (NSString *)applicationSupportDirectory;
- (NSArray *)loadAllBundlesWithExtension:(NSString *)ext;
- (NSMutableArray *)allBundlesWithExtension:(NSString *)ext;

@end


@implementation AppDelegate

@synthesize window, messagesArrayController;

- (id)init {
  if (self = [super init]) {
    operationQueue = [[NSOperationQueue alloc] init];

    [self loadSources];
    [self loadNotifiers];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:managedObjectContext];
  }
  return self;
}

#pragma mark -
#pragma mark NSApplicationDelegate methods

- (void)awakeFromNib {
  // Sort messages by date received (descending).
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"received" ascending:NO];
  [messagesArrayController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [self registerDefaults];

  for (Source *source in sources) {
    [source setEnabled:YES];
  }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  for (Source *source in sources) {
    [source setEnabled:NO];
  }
  
  [operationQueue cancelAllOperations];
}

#pragma mark -
#pragma mark SourceDelegate methods

- (void)updateSource:(Source *)source {
  NSOperation *updateOperation = [[NSInvocationOperation alloc] initWithTarget:source selector:@selector(update) object:nil];
  [operationQueue addOperation:updateOperation];
}

#pragma mark -
#pragma mark Private methods

- (void)registerDefaults {
  NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"NoiseDefaults" ofType:@"plist"];
  NSDictionary *defaultsDictionary = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)contextDidSave:(NSNotification *)notification {
  NSArray *objects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
  for (id object in objects) {
    if ([object isMemberOfClass:[Message class]]) {
      NSLog(@"%@", object);
      [self messageReceived:object];
    }
  }
}

- (void)messageReceived:(Message *)message {
  for (Notifier *notifier in notifiers) {
    [notifier notify:message];
  }
}

- (void)loadNotifiers {
  notifiers = [NSMutableArray array];
  NSArray *klasses = [self loadAllBundlesWithExtension:@"noiseNotifier"];
  
  for (Class klass in klasses) {
    // TODO: validate the plug-in.
    Notifier *notifier = [[klass alloc] init];
    [notifiers addObject:notifier];
  }
}

- (void)loadSources {
  sources = [NSMutableArray array];
  NSArray *klasses = [self loadAllBundlesWithExtension:@"noiseSource"];
  
  for (Class klass in klasses) {
    // TODO: validate the plug-in.
    Source *source = [[klass alloc] initWithDelegate:self];
    [sources addObject:source];
  }
}

/**
 Returns the support directory for the application, used to store the Core Data
 store file.  This code uses a directory named "Noise" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */
- (NSString *)applicationSupportDirectory {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
  return [basePath stringByAppendingPathComponent:@"Noise"];
}


/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (managedObjectModel) return managedObjectModel;
  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
  return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (persistentStoreCoordinator) return persistentStoreCoordinator;
  
  NSManagedObjectModel *mom = [self managedObjectModel];

  if (!mom) {
    NSAssert(NO, @"Managed object model is nil");
    NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
    return nil;
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *applicationSupportDirectory = [self applicationSupportDirectory];
  NSError *error = nil;
  
  if (![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL]) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
      NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory, error]));
      NSLog(@"Error creating application support directory at %@ : %@", applicationSupportDirectory, error);
      return nil;
		}
  }
  
  NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"storedata"]];
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];

  if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
                                                configuration:nil 
                                                          URL:url 
                                                      options:nil 
                                                        error:&error]) {
    [[NSApplication sharedApplication] presentError:error];
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    return nil;
  }    
  
  return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext) return managedObjectContext;
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

  if (!coordinator) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
    [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }

  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator:coordinator];
  
  return managedObjectContext;
}

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
  return [[self managedObjectContext] undoManager];
}

- (NSArray *)loadAllBundlesWithExtension:(NSString *)ext {
  NSMutableArray *instances;
  NSMutableArray *bundlePaths;
  NSEnumerator *pathEnum;
  NSString *currPath;
  NSBundle *currBundle;
  Class currPrincipalClass;
  
  instances = [NSMutableArray array];
  bundlePaths = [NSMutableArray array];
  
  [bundlePaths addObjectsFromArray:[self allBundlesWithExtension:ext]];
  pathEnum = [bundlePaths objectEnumerator];
  
  while (currPath = [pathEnum nextObject]) {
    currBundle = [NSBundle bundleWithPath:currPath];
    if (currBundle) {
      currPrincipalClass = [currBundle principalClass];
      if (currPrincipalClass) {
        [instances addObject:currPrincipalClass];
      }
    }
  }
  
  return instances;
}

- (NSMutableArray *)allBundlesWithExtension:(NSString *)ext {
  NSArray *librarySearchPaths;
  NSEnumerator *searchPathEnum;
  NSString *currPath;
  NSMutableArray *bundleSearchPaths = [NSMutableArray array];
  NSMutableArray *allBundles = [NSMutableArray array];

  librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
  searchPathEnum = [librarySearchPaths objectEnumerator];
  
  while (currPath = [searchPathEnum nextObject]) {
    [bundleSearchPaths addObject:[currPath stringByAppendingPathComponent:APP_SUPPORT_PLUGIN_DIR]];
  }
  
  [bundleSearchPaths addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
  searchPathEnum = [bundleSearchPaths objectEnumerator];
  
  while (currPath = [searchPathEnum nextObject]) {
    NSDirectoryEnumerator *bundleEnum;
    NSString *currBundlePath;
    bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
    if (bundleEnum) {
      while (currBundlePath = [bundleEnum nextObject]) {
        if ([[currBundlePath pathExtension] isEqualToString:ext]) {
          [allBundles addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
        }
      }
    }
  }
  
  return allBundles;
}
    
@end
