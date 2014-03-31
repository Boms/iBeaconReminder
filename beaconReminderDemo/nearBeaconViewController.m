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
#import "updateNameViewController.h"
#import "selectNameForBeaconTableViewController.h"
#import "graBeaconManagerTableViewController.h"
#import "graCreateReminderTableViewController.h"
#import "graCreateBeaconNameTableViewController.h"
#import "graAddReminderTableView.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "graUITableViewCell.h"
#import "colorForMarker.h"
@interface nearBeaconViewController ()
@property (nonatomic, strong) iBeaconUser *myUser;
@property (nonatomic, strong) NSMutableArray *beaconArray;
@property (nonatomic, strong) NSMutableArray *namedBeacon;
@property (nonatomic, strong) NSMutableArray *unamedBeacon;
@property (nonatomic, strong) CLBeacon *lastFoundBeacon;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *composeButton;
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

-(NSMutableArray *)namedBeacon
{
    if (!_namedBeacon) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        _myUser = user;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSDictionary *eachBeaconName in user.namesOfBeacon) {
            NSData *archieved = [eachBeaconName objectForKey:@"beacon"];
            CLBeacon *beacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
            [result addObject:beacon];
        }
        _namedBeacon = result;
    }
    return _namedBeacon;
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

    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BEACONMANAGEMENT", @"edit for location") style:UIBarButtonItemStyleBordered target:self action:@selector(showBeaconManagement)];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewReminder)];
    self.composeButton = btn;
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, btn, flexSpace];
    self.title = NSLocalizedString(@"LISTS", @"this page title");
    self.tableView.separatorColor = [colorForMarker markerColor];
//    self.navigationController.toolbar.barTintColor
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
}



-(void)viewDidAppear:(BOOL)animated{
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if ([user.namesOfBeacon count] == 0) {
        [self.composeButton setEnabled:NO];
    }else{
        [self.composeButton setEnabled:YES];
    }
    self.navigationController.toolbarHidden = NO;
    self.namedBeacon = nil;
    _myUser = user;
    [self.myUser startMonitorWithFoundNewBeacon:^(CLBeacon *foundOne){
        ;
    } withKnowBeacon:^(CLBeacon *foundOne){
        NSInteger i = 0;
        if ([user findNameByBeacon:foundOne]) {
            for (;i < [self.namedBeacon count] ; i++) {
                CLBeacon *eachNamedBeacon = [self.namedBeacon objectAtIndex:i];
                if ([user isBeacon:eachNamedBeacon SameWith:foundOne]) {
                    [self.namedBeacon replaceObjectAtIndex:i withObject:foundOne];
                    break;
                }
            }
            if (i == [self.namedBeacon count]){
                [self.namedBeacon addObject:foundOne];
            }
            [self.tableView reloadData];
        }else{
            [user replaceBeacon:foundOne inArray:self.unamedBeacon];
            [self.tableView reloadData];
        }
    }];
    
    //check background status
    if (!([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable)) {
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"Got it" action:^{
            // this is the code that will be executed when the user taps "No"
            // this is optional... if you leave the action as nil, it won't do anything
            // but here, I'm showing a block just to show that you can use one if you want to.
        }];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PLEASE_ENABLE_BACKGROUND_APP", @"app background is disable")
                                                            message:NSLocalizedString(@"APP_FAILED_TO_WORK", @"app will failed to serve you")
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:nil, nil];
        [alertView show];
    }
    
    //check location monitor status
    if([CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied || kCLAuthorizationStatusRestricted == [CLLocationManager  authorizationStatus])
    {
        RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"Got it" action:^{
            // this is the code that will be executed when the user taps "No"
            // this is optional... if you leave the action as nil, it won't do anything
            // but here, I'm showing a block just to show that you can use one if you want to.
        }];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PLEASE_ENABLE_LOCATING_APP", @"location service is disable")
                                                            message:NSLocalizedString(@"APP_FAILED_TO_WORK", @"app will failed to serve you")
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:nil, nil];
        [alertView show];
    }
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.unamedBeacon = nil;
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


-(NSMutableArray *)beaconArray
{
    if (_beaconArray == Nil) {
        _beaconArray = [[NSMutableArray alloc] init];
    }
    return _beaconArray;
}
-(NSMutableArray *)unamedBeacon
{
    if(_unamedBeacon == nil){
        _unamedBeacon = [[NSMutableArray alloc] init];
    }
    return _unamedBeacon;
}


#pragma mark button action
-(void)showBeaconManagement
{
    graBeaconManagerTableViewController *vc = [[graBeaconManagerTableViewController alloc] initWithNibName:@"graBeaconManagerTableViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) createNewReminder
{
#if 0
    graCreateReminderViewController *vc = [[graCreateReminderViewController alloc] initWithNibName:@"graCreateReminderViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
#endif

    graCreateReminderTableViewController *vc = [[graCreateReminderTableViewController alloc] initWithNibName:@"graCreateReminderTableViewController" bundle:nil];
    vc.title = NSLocalizedString(@"NEWREMINDER_TITLE", @"user compose new reminder title for view controller ");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)adjustToolbarSize
{
    // size up the toolbar and set its frame
	[self.toolbar sizeToFit];
    
    // since the toolbar may have adjusted its height, it's origin will have to be adjusted too
	CGRect mainViewBounds = self.view.bounds;
	[self.toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
                                      CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - CGRectGetHeight(self.toolbar.frame),
                                      CGRectGetWidth(mainViewBounds),
                                      CGRectGetHeight(self.toolbar.frame))];
}



#pragma mark - Table view data source
#if 0
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < [self.namedBeacon count]) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        CLBeacon *thisOne = self.namedBeacon[section];
        NSString *beaconLocaton = [user findNameByBeacon:thisOne];
        return [NSLocalizedString(@"AT", @"prefix word for location") stringByAppendingString:beaconLocaton];
    }else{
        return NSLocalizedString(@"FOUNDNEWDEVICE", @"found new device title");
    }
}
#endif

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static UIView *footerView;
    
    if (footerView != nil)
        return footerView;
    
    if ([self isNoneBeaconFound]) {
        return nil;
    }
    // set the container width to a known value so that we can center a label in it
    // it will get resized by the tableview since we set autoresizeflags
    float footerWidth = 150.0f;
    float padding = 10.0f; // an arbitrary amount to center the label in the container
    
    // create the label centered in the container, then set the appropriate autoresize mask
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, footerWidth - 2.0f * padding, 44.0f)];
    footerLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.textColor = [UIColor grayColor];
    NSString *title = nil;
    if (section < [self.namedBeacon count]) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        CLBeacon *thisOne = self.namedBeacon[section];
        NSString *beaconLocaton = [user findNameByBeacon:thisOne];
        title =  [NSLocalizedString(@"AT", @"prefix word for location") stringByAppendingString:beaconLocaton];
    }else{
        title =  NSLocalizedString(@"FOUNDNEWDEVICE", @"found new device title");
    }

    footerLabel.text = title;
    return footerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(BOOL)isNoneBeaconFound
{
    NSInteger count = [self.namedBeacon count];
    if ([self.unamedBeacon count]) {
        count++;
    }
    if(count == 0)
        return YES;
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger count = [self.namedBeacon count];
    if ([self.unamedBeacon count]) {
        count++;
    }
    if (count == 0) {
        return 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isNoneBeaconFound]) {
        return 1;
    }
    // Return the number of rows in the section.
    if (section < [self.namedBeacon count]) {
        CLBeacon *thisOne = nil;
        iBeaconUser *user = [iBeaconUser sharedInstance];
        thisOne = self.namedBeacon[section];
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:thisOne];
        NSInteger count = [reminderOfBeacon count];
        if (count == 0) {
            return 1;
        }
        return count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    graUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[graUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CLBeacon *thisOne = nil;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    
    if ([self isNoneBeaconFound]) {
        
        cell.textLabel.text = NSLocalizedString(@"GO_BUY_ONE", @"enable user to buy one through website");
        cell.detailTextLabel.text = NSLocalizedString(@"NO_BEACON_FOUND", @"nothing found now");
        return cell;
        
    }
    if (indexPath.section < [self.namedBeacon count]) {

        thisOne = self.namedBeacon[indexPath.section];
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:thisOne];
        if ([reminderOfBeacon count] == 0) {
            cell.textLabel.text = NSLocalizedString(@"ADDFIRSTREMINDER", @"encourage user to input 1st reminder");
            return cell;
        }
        NSDictionary *reminderDict = [reminderOfBeacon objectAtIndex:indexPath.row];
        NSString *reminder = [reminderDict objectForKey:@"reminder"];
        cell.textLabel.text = reminder;
        NSString *friends = [reminderDict objectForKey:@"friends"];
        if (friends && [friends length] != 0) {
            cell.detailTextLabel.text = [@"@" stringByAppendingString: friends];
        }
        return cell;
    }else{
        NSString *founded_pre = NSLocalizedString(@"FOUND_PREFIX", @"found");
        NSString *device =  nil;
        if ([self.unamedBeacon count] == 1) {
            device = NSLocalizedString(@"DEVICE", @"device");
        }else{
            device = NSLocalizedString(@"DEVICES", @"devices");
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %ld %@",founded_pre, [self.unamedBeacon count], device];
        cell.detailTextLabel.text = @"";
        return cell;
    }
}



#if 0
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

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    CLBeacon *thisOne = nil;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if ([self isNoneBeaconFound]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"WEBSITE_URL", @"url to buy beacon")]];
        return;
    }

    if (indexPath.section < [self.namedBeacon count]) {
        thisOne = self.namedBeacon[indexPath.section];
        CLBeacon *selectedBeacon = thisOne;
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:selectedBeacon];
        graAddReminderTableView *vc  = [[graAddReminderTableView alloc] initWithNibName:@"graAddReminderTableView" bundle:nil];
        vc.myBeacon = selectedBeacon;

        if ([reminderOfBeacon count]) {
            NSDictionary *reminderDict = [reminderOfBeacon objectAtIndex:indexPath.row];
            NSString *reminder = [reminderDict objectForKey:@"reminder"];
            vc.reminder = reminder;
            vc.reminderDict = [NSMutableDictionary dictionaryWithDictionary:reminderDict];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        thisOne = self.unamedBeacon[indexPath.row];
        graCreateBeaconNameTableViewController *vc = [[graCreateBeaconNameTableViewController alloc] initWithNibName:@"graCreateBeaconNameTableViewController" bundle:nil];
        vc.title = NSLocalizedString(@"WHERE_BEACON_IS", @"title for select location for beacon");
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

@end
