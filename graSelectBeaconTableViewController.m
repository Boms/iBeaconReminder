//
//  graSelectBeaconTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/25/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graSelectBeaconTableViewController.h"

@interface graSelectBeaconTableViewController ()

@end

@implementation graSelectBeaconTableViewController

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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    iBeaconUser *user = [iBeaconUser sharedInstance];
    return [user.namesOfBeacon count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
        NSString *title = nil;
        iBeaconUser *user = [iBeaconUser sharedInstance];
        NSDictionary *each = [user.namesOfBeacon objectAtIndex:indexPath.row];
        NSData *archieved = [each objectForKey:@"beacon"];
        CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];

        NSString *beaconName = [each objectForKey:@"name"];
        title = beaconName;
        cell.textLabel.text = title;
        if ([user isBeacon:self.seletedBeacon SameWith:thisBeacon]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    iBeaconUser *user = [iBeaconUser sharedInstance];

    NSDictionary *each = [user.namesOfBeacon objectAtIndex:indexPath.row];
    NSData *archieved = [each objectForKey:@"beacon"];
    CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
    if(self.beaconSelected){
        self.beaconSelected(thisBeacon);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
