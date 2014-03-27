//
//  selectNameForBeaconTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/19/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "selectNameForBeaconTableViewController.h"
#import "updateNameViewController.h"
#import "NSString+Emojize.h"
@interface selectNameForBeaconTableViewController ()

@end

@implementation selectNameForBeaconTableViewController

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
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

-(NSString *)iPhone
{
//    return [[NSString emojizedStringWithString:@":iphone:"] stringByAppendingString: @"  手机"];
    return [NSLocalizedString(@"ALLTIME", @"all time reminder") stringByAppendingString:[NSString emojizedStringWithString:@":handbag:"]];
}

-(NSString *)home
{
//    return [[NSString emojizedStringWithString:@":house:"] stringByAppendingString: @"   家"];
    return [NSLocalizedString(@"HOME", @"arrive at home") stringByAppendingString:[NSString emojizedStringWithString:@":house:"]];

}
-(NSString *)office
{
//    return [[NSString emojizedStringWithString:@":computer:"] stringByAppendingString: @"办公室"];
    return [NSLocalizedString(@"OFFICE", @"arrive at office") stringByAppendingString:[NSString emojizedStringWithString:@":computer:"]];

}
-(NSString *)car
{
//    return [[NSString emojizedStringWithString:@":red_car:"] stringByAppendingString:  @"   车"];
    return [NSLocalizedString(@"CAR", @"enter car") stringByAppendingString:[NSString emojizedStringWithString:@":red_car:"]];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    
    if (indexPath.section == 0) {
        //show know name
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [self iPhone];
                break;
            case 1:
                cell.textLabel.text = [self home];
                break;
            case 2:
                cell.textLabel.text = [self office];
                break;
            case 3:
                cell.textLabel.text = [self car];
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我要自己想一个的名字";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    if (indexPath.section == 0) {
        //show know name
        NSString *beaconName = nil;
        switch (indexPath.row) {
            case 0:
                beaconName = [self iPhone];
                break;
            case 1:
                beaconName = [self home];
                break;
            case 2:
                beaconName = [self office];
                break;
            case 3:
                beaconName = [self car];
                break;
            default:
                break;
        }
        iBeaconUser *user = [iBeaconUser sharedInstance];
        [user setNameForBeacon:self.myBeacon with:beaconName];
        [user saveAllData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            updateNameViewController *vc = [[updateNameViewController alloc] initWithNibName:@"updateNameViewController" bundle:nil];
            vc.myBeacon = self.myBeacon;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
