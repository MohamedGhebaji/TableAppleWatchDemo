//
//  CoreDataStack.h
//  TableAppleWatchDemo
//
//  Created by Mohamed on 11/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
- (void)saveContext;
@end
