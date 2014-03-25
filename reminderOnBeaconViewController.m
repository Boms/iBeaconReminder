//
//  reminderOnBeaconViewController.m
//  beaconDemo
//
//  Created by li lin on 3/3/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "reminderOnBeaconViewController.h"
#import "updateNameViewController.h"
#import "graAddReminderTableView.h"
@interface reminderOnBeaconViewController ()
@property (nonatomic, strong) UIBarButtonItem *removeButton;
@property (nonatomic, strong) UIBarButtonItem *composeButton;
@end

@implementation reminderOnBeaconViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doneEditing
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = nil;

    [self.composeButton setEnabled:YES];
    if ([self tableView:self.tableView numberOfRowsInSection:0] != 0) {
        [self.removeButton setEnabled:YES];
    }
}

-(void)prepareRemoveReminder
{
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [self.removeButton setEnabled:NO];
    [self.composeButton setEnabled:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *remove =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(prepareRemoveReminder)];
    self.removeButton = remove;
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pushToAddReminderOnThisBeacon)];
    self.composeButton = btn;
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, btn, flexSpace, remove,flexSpace];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self tableView:self.tableView numberOfRowsInSection:0] != 0) {
        [self.removeButton setEnabled:YES];
    }else{
        [self.removeButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    iBeaconUser *user = [iBeaconUser sharedInstance];
    NSMutableArray *reminderOfBeacon = [user findRemindersWith:self.myBeacon];
    return [reminderOfBeacon count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    iBeaconUser *user  = [iBeaconUser sharedInstance];
    NSMutableArray *reminderOfBeacon = [user findRemindersWith:self.myBeacon];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *reminderDict = [reminderOfBeacon objectAtIndex:indexPath.row];
    NSString *reminder = [reminderDict objectForKey:@"reminder"];
    cell.textLabel.text = reminder;
    NSString *friends = [reminderDict objectForKey:@"friends"];
    if (friends && [friends length] != 0) {
        cell.detailTextLabel.text = [@"@" stringByAppendingString: friends];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        iBeaconUser *user  = [iBeaconUser sharedInstance];
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:self.myBeacon];
        NSDictionary *reminder = [reminderOfBeacon objectAtIndex:indexPath.row];
        [user removeReminderWith:self.myBeacon with:[reminder objectForKey:@"reminder"]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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

-(void)pushToAddReminderOnThisBeacon
{
    graAddReminderTableView *vc = [[graAddReminderTableView alloc] initWithNibName:@"graAddReminderTableView" bundle:nil];
    vc.reminder = nil;
    vc.myBeacon = self.myBeacon;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    vc.title = [@"in " stringByAppendingString:[user findNameByBeacon:self.myBeacon]];;
    [self.navigationController pushViewController:vc animated:YES];
    return;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    iBeaconUser *user  = [iBeaconUser sharedInstance];

        graAddReminderTableView *vc = [[graAddReminderTableView alloc] initWithNibName:@"graAddReminderTableView" bundle:nil];
        NSMutableArray *reminderStringArray = [user findRemindersWith:self.myBeacon];
        NSDictionary *reminderDict = [reminderStringArray objectAtIndex:indexPath.row];
        NSString *reminderString = [reminderDict objectForKey:@"reminder"];
        vc.reminder = reminderString;
        vc.myBeacon = self.myBeacon;
        vc.reminderDict = reminderDict;
        vc.title = [@"in " stringByAppendingString:[user findNameByBeacon:self.myBeacon]];
        [self.navigationController pushViewController:vc animated:YES];
    return;
    
}

@end
