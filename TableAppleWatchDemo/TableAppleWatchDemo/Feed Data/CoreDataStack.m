//
//  CoreDataStack.m
//  TableAppleWatchDemo
//
//  Created by Mohamed on 11/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import "CoreDataStack.h"
#import "Post.h"

@interface  CoreDataStack()

@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStore *store;

- (void)_loadStarterData;

@end

@implementation CoreDataStack

#pragma mark - Public Methods

+ (instancetype)sharedManager {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)createContetxt {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *modelURL = [bundle URLForResource:@"data" withExtension:@"momd"];
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.psc;
    
    NSError *error;
    self.store = [self.psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];

    [self _loadStarterData];
}

- (void)saveContext {
    NSError *error;
    if ([self.context hasChanges] && ![self.context save:&error]) {
        NSLog(@"Could not save : %@", error.userInfo);
    }
}

- (NSArray *)allPosts {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]];
    NSArray *result = [self.context executeFetchRequest:fetch error:NULL];
    if (result && result.count > 0) {
        return result;
    }
    
    return @[];
}

- (Post *)mostRecentPost {
    NSArray *results = [self allPosts];
    if (results && results.count > 0) {
        return [results firstObject];
    }
    
    return nil;
}

#pragma mark - Private Methods
- (void)_loadStarterData {
    
    NSURL *plistURL = [[NSBundle bundleForClass:[CoreDataStack class]] URLForResource:@"data" withExtension:@"plist"];
    if (plistURL) {
        NSArray *starterDataArray = [NSArray arrayWithContentsOfURL:plistURL];
        for (NSDictionary *post in starterDataArray) {
            Post *itemObject;
            
            NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
            fetch.predicate = [NSPredicate predicateWithFormat:@"identifier = %@" argumentArray:@[post[@"identifier"]]];
            
            NSArray *result = [self.context executeFetchRequest:fetch error:NULL];
            if (result.count > 0) {
                itemObject = result[0];
            }
            
            if (itemObject == nil) {
                itemObject = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.context];
            }
            
            [itemObject setValue:post[@"category"]  forKey: @"category"];
            [itemObject setValue:post[@"identifier"] forKey: @"identifier"];
            [itemObject setValue:post[@"link"] forKey: @"link"];
            [itemObject setValue:post[@"timestamp"] forKey: @"timestamp"];
            [itemObject setValue:post[@"title"] forKey: @"title"];
        }
    }
    
    [self saveContext];
}

@end
