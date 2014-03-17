//
//  reminderOnBeaconViewController.h
//  beaconDemo
//
//  Created by li lin on 3/3/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBeaconUser.h"

@interface reminderOnBeaconViewController : UITableViewController
@property (nonatomic, strong) CLBeacon *myBeacon;
@end
