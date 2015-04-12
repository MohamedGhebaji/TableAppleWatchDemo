//
//  PostRowController.h
//  TableAppleWatchDemo
//
//  Created by Mohamed on 12/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface PostRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *dateLabel;

@end
