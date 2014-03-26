//
//  graSelectTimeTableViewController.h
//  beaconReminderDemo
//
//  Created by li lin on 3/26/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBeaconUser.h"
@interface graSelectTimeTableViewController : UITableViewController
@property (nonatomic, strong) void (^timerSelected)(NSDictionary *);
@property (nonatomic, strong) NSDictionary *reminderDict;
@end
