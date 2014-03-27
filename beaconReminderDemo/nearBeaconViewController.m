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

    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithTitle:@"设备管理" style:UIBarButtonItemStyleBordered target:self action:@selector(showBeaconManagement)];
    [btnItem setTitle:@"位置管理"];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createNewReminder)];
    self.composeButton = btn;
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, btn, flexSpace];

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
    vc.title = @"创建新提醒";
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < [self.namedBeacon count]) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        CLBeacon *thisOne = self.namedBeacon[section];
        NSString *beaconLocaton = [user findNameByBeacon:thisOne];
        return [@"在" stringByAppendingString: beaconLocaton];
    }else{
        return @"新设备";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger count = [self.namedBeacon count];
    if ([self.unamedBeacon count]) {
        count++;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section < [self.namedBeacon count]) {
        CLBeacon *thisOne = nil;
        iBeaconUser *user = [iBeaconUser sharedInstance];
        thisOne = self.namedBeacon[section];
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:thisOne];
        NSInteger count = [reminderOfBeacon count];
        return count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CLBeacon *thisOne = nil;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    
    if (indexPath.section < [self.namedBeacon count]) {
        thisOne = self.namedBeacon[indexPath.section];
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:thisOne];
        NSDictionary *reminderDict = [reminderOfBeacon objectAtIndex:indexPath.row];
        NSString *reminder = [reminderDict objectForKey:@"reminder"];
        cell.textLabel.text = reminder;
        NSString *friends = [reminderDict objectForKey:@"friends"];
        if (friends && [friends length] != 0) {
            cell.detailTextLabel.text = [@"@" stringByAppendingString: friends];
        }
        return cell;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"发现 %d 个", [self.unamedBeacon count]];
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

    if (indexPath.section < [self.namedBeacon count]) {
        thisOne = self.namedBeacon[indexPath.section];
        CLBeacon *selectedBeacon = thisOne;
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:selectedBeacon];
        graAddReminderTableView *vc  = [[graAddReminderTableView alloc] initWithNibName:@"graAddReminderTableView" bundle:nil];
        vc.myBeacon = selectedBeacon;
        NSDictionary *reminderDict = [reminderOfBeacon objectAtIndex:indexPath.row];
        NSString *reminder = [reminderDict objectForKey:@"reminder"];
        vc.reminder = reminder;
        vc.reminderDict = [NSMutableDictionary dictionaryWithDictionary:reminderDict];

        [self.navigationController pushViewController:vc animated:YES];
    }else{
        thisOne = self.unamedBeacon[indexPath.row];
        graCreateBeaconNameTableViewController *vc = [[graCreateBeaconNameTableViewController alloc] initWithNibName:@"graCreateBeaconNameTableViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

@end
