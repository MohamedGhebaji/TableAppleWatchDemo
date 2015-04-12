//
//  InterfaceController.m
//  TableAppleWatchDemo WatchKit Extension
//
//  Created by Mohamed on 11/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import "InterfaceController.h"
#import "CoreDataStack.h"
#import "Post.h"
#import "PostRowController.h"

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) CoreDataStack *coreDataStack;
@property (nonatomic, copy) NSArray *posts;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation InterfaceController

#pragma mark - Life Cycle
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    self.coreDataStack = [CoreDataStack sharedManager];
    [self.coreDataStack createContetxt];
    self.posts = [NSArray arrayWithArray:[self.coreDataStack allPosts]];
    
    //[self.table insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)] withRowType:@"PostRowType"];
    
    [self.table setNumberOfRows:self.posts.count withRowType:@"PostRowType"];
    for (int i = 0; i < self.posts.count; i++) {
        Post *post = self.posts[i];
        PostRowController *row = [self.table rowControllerAtIndex:i];
        [row.titleLabel setText:post.title];
        [row.dateLabel setText:[self.dateFormatter stringFromDate:post.timestamp]];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Accesories

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return dateFormatter;
}

@end



