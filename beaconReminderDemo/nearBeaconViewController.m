//
//  nearBeaconViewController.m
//  beaconDemo
//
//  Created by li lin on 1/11/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "nearBeaconViewController.h"
#import "iBeaconUser.h"
#import "reminderOnBeaconViewController.h"
@interface nearBeaconViewController ()
@property (nonatomic, strong) iBeaconUser *myUser;
@property (nonatomic, strong) NSMutableArray *beaconArray;
@property (nonatomic, strong) CLBeacon *lastFoundBeacon;
@end

@implementation nearBeaconViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)beaconArray
{
    if (_beaconArray == Nil) {
        _beaconArray = [[NSMutableArray alloc] init];
    }
    return _beaconArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    _myUser = user;
    [self.myUser stopMonitor];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    iBeaconUser *user = [iBeaconUser sharedInstance];
    _myUser = user;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.myUser startMonitorWithFoundNewBeacon:^(CLBeacon *foundOne){
            [self.beaconArray addObject:foundOne];
            [self.tableView reloadData];
        } withKnowBeacon:^(CLBeacon *foundOne){
            NSInteger len = 0;
            for (; len < [self.beaconArray count]; len++) {
                CLBeacon *eachBeacon = [self.beaconArray objectAtIndex:len];
                if ([eachBeacon.proximityUUID isEqual:foundOne.proximityUUID]) {
                    if([eachBeacon.major isEqualToNumber:foundOne.major]){
                        if([eachBeacon.minor isEqualToNumber:foundOne.minor]){
                            [self.beaconArray replaceObjectAtIndex:len withObject:foundOne];
                            [self.tableView reloadData];
                            break;
                        }
                    }
                }
            }
            if (len == [self.beaconArray count]) {
                [self.beaconArray addObject:foundOne];
                [self.tableView reloadData];
            }
        }];
    });

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    iBeaconUser *user = [iBeaconUser sharedInstance];
    _myUser = user;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.beaconArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    CLBeacon *thisOne = self.beaconArray[indexPath.row];
    iBeaconUser *user = [iBeaconUser sharedInstance];
    NSString *title =[NSString stringWithFormat:@"Ma-%04x Mi-%04x:%d", [thisOne.major integerValue], [thisOne.minor integerValue], thisOne.rssi];

    if (thisOne.proximity == CLProximityFar) {
        title = [title stringByAppendingString:@" Far"];
        if (self.lastFoundBeacon) {
            NSInteger averageRSSI = (thisOne.rssi + self.lastFoundBeacon.rssi);
            averageRSSI  = ABS(averageRSSI)/2;
            if (averageRSSI < 82) {
                title = [title stringByAppendingString:@" M"];
            }else if (averageRSSI < 95){
                title = [title stringByAppendingString:@" L"];
            }
        }else{
            self.lastFoundBeacon = thisOne;
        }
    }
    if (thisOne.proximity == CLProximityUnknown) {
        title = [title stringByAppendingString:@" Unknown"];
    }
    if (thisOne.proximity == CLProximityNear) {
        title = [title stringByAppendingString:@" Near"];
    }
    if (thisOne.proximity == CLProximityImmediate) {
        title = [title stringByAppendingString:@" Immediate"];
    }
    NSString *detail =[@"uuid-" stringByAppendingString:[thisOne.proximityUUID UUIDString]];
    
    NSString *beaconLocaton = [user findNameByBeacon:thisOne];
    if (beaconLocaton) {
        cell.textLabel.text = beaconLocaton;
        cell.detailTextLabel.text = title;
    }else{
        cell.detailTextLabel.text = detail;
        cell.textLabel.text = title;
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#if 1
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
#endif

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    reminderOnBeaconViewController *detailViewController = [[reminderOnBeaconViewController alloc] initWithNibName:@"reminderOnBeaconViewController" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    CLBeacon *selectedBeacon = self.beaconArray[indexPath.row];
    detailViewController.myBeacon = selectedBeacon;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
