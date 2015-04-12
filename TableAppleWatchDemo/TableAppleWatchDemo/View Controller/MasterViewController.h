//
//  MasterViewController.h
//  TableAppleWatchDemo
//
//  Created by Mohamed on 11/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface MasterViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
