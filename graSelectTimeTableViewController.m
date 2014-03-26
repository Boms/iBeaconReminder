//
//  graSelectTimeTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/26/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graSelectTimeTableViewController.h"

@interface graSelectTimeTableViewController ()

@end

@implementation graSelectTimeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString * timerTextPresent = nil;
    // Configure the cell...
    if (self.reminderDict) {
            NSMutableDictionary *fullInfo = self.reminderDict[@"fullInfo"];
        if (fullInfo) {
            NSDictionary *timerObj = fullInfo[@"timer"];
            if (timerObj) {
                timerTextPresent = timerObj[@"textPresent"];
            }
        }
    }
    if (indexPath.section == 0) {
        //show know name
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"早上";
                break;
            case 1:
                cell.textLabel.text = @"上午";
                break;
            case 2:
                cell.textLabel.text = @"中午";
                break;

            case 3:
                cell.textLabel.text = @"下午";
                break;
            case 4:
                cell.textLabel.text = @"晚上";
                break;
            default:
                break;
        }
        if ([timerTextPresent isEqualToString:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"另选时间";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                self.timerSelected([user selectMorningTimer]);
                break;
            case 1:
                self.timerSelected([user selectAMTimer]);
                break;
            case 2:
                self.timerSelected([user selectNoonTimer]);
                break;
            case 3:
                self.timerSelected([user selectAfterNoonTimer]);
                break;
            case 4:
                self.timerSelected([user selectEvevningTimer]);
                break;
            default:
                break;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.section == 1) {
    }
}

@end
