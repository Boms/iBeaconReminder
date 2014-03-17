//
//  reminderOnBeaconViewController.m
//  beaconDemo
//
//  Created by li lin on 3/3/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "reminderOnBeaconViewController.h"
#import "updateNameViewController.h"
#import "AddReminderOfBeacon.h"
@interface reminderOnBeaconViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.

    if (section == 0) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 1) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        NSMutableArray *reminderOfBeacon = [user findRemindersWith:self.myBeacon];
        return [reminderOfBeacon count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    iBeaconUser *user  = [iBeaconUser sharedInstance];
    NSMutableArray *reminderOfBeacon = [user findRemindersWith:self.myBeacon];
    if (indexPath.section == 0) {
        NSString *title = [user findNameByBeacon:self.myBeacon];
        if (title) {
            cell.textLabel.text = [@"in " stringByAppendingString:title];
        }else{
            cell.textLabel.text = @"设置位置";
        }
        return cell;
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"添加提醒";
        return cell;
    }

    if (indexPath.section == 1) {
        NSDictionary *reminderDict = [reminderOfBeacon objectAtIndex:indexPath.row];
        NSString *reminder = [reminderDict objectForKey:@"reminder"];
        cell.textLabel.text = reminder;
        NSString *friends = [reminderDict objectForKey:@"friends"];
        if (friends) {
            cell.detailTextLabel.text = [@"@" stringByAppendingString: friends];
        }
    }
    
    // Configure the cell...
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    iBeaconUser *user  = [iBeaconUser sharedInstance];

    if (indexPath.section == 0) {
        updateNameViewController *detailViewController = [[updateNameViewController alloc] initWithNibName:@"updateNameViewController" bundle:nil];
        detailViewController.myBeacon = self.myBeacon;
        [self.navigationController pushViewController:detailViewController animated:YES];
        return;
    }
    if (indexPath.section == 2) {
        AddReminderOfBeacon *vc = [[AddReminderOfBeacon alloc] initWithNibName:@"AddReminderOfBeacon" bundle:nil];
        vc.reminder = nil;
        vc.myBeacon = self.myBeacon;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1) {
        AddReminderOfBeacon *vc = [[AddReminderOfBeacon alloc] initWithNibName:@"AddReminderOfBeacon" bundle:nil];
        NSMutableArray *reminderStringArray = [user findRemindersWith:self.myBeacon];
        NSDictionary *reminderDict = [reminderStringArray objectAtIndex:indexPath.row];
        NSString *reminderString = [reminderDict objectForKey:@"reminder"];
        vc.reminder = reminderString;
        vc.myBeacon = self.myBeacon;
        vc.reminderDict = reminderDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return;
    
}

@end
