//
//  graAddReminderTableView.h
//  beaconReminderDemo
//
//  Created by li lin on 3/25/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBeaconUser.h"
@interface graAddReminderTableView : UITableViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *reminder;
@property (nonatomic, strong) NSDictionary *reminderDict;
@property (nonatomic, strong) CLBeacon *myBeacon;
@end
