//
//  graCreateBeaconNameTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/21/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graCreateBeaconNameTableViewController.h"
#import "updateNameViewController.h"
#import "selectNameForBeaconTableViewController.h"

@interface graCreateBeaconNameTableViewController ()
@property (nonatomic, strong) iBeaconUser *myUser;
@property (nonatomic, strong) NSMutableArray *beaconArray;
@property (nonatomic, strong) NSMutableArray *namedBeacon;
@property (nonatomic, strong) NSMutableArray *unamedBeacon;

@end

@implementation graCreateBeaconNameTableViewController


-(NSMutableArray *)unamedBeacon
{
    if(_unamedBeacon == nil){
        _unamedBeacon = [[NSMutableArray alloc] init];
    }
    return _unamedBeacon;
}

-(NSMutableArray *)namedBeacon
{
    if(_namedBeacon == nil){
        _namedBeacon = [[NSMutableArray alloc] init];
    }
    return _namedBeacon;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    iBeaconUser *user = [iBeaconUser sharedInstance];
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
    return [self.unamedBeacon count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    CLBeacon *thisOne = nil;
    thisOne = self.unamedBeacon[indexPath.row];
    NSString *uuid =[NSString stringWithFormat:@"%04x %04x", [thisOne.major integerValue], [thisOne.minor integerValue]];
    NSString *distance = nil;
    
    switch (thisOne.proximity) {
        case CLProximityFar:
            distance = @"                                远";
            break;
        case CLProximityNear:
            distance = @"               近";
            break;
        case CLProximityImmediate:
            distance = @" 贴住";
            break;
        default:
            break;
    }
    

    cell.textLabel.text = @"起个名字吧";
    cell.detailTextLabel.text = [uuid stringByAppendingString:distance];
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *selectedBeacon = nil;
    selectedBeacon = self.unamedBeacon[indexPath.row];
    selectNameForBeaconTableViewController *detailViewController = [[selectNameForBeaconTableViewController alloc] initWithNibName:@"selectNameForBeaconTableViewController" bundle:nil];
    detailViewController.myBeacon = selectedBeacon;
    [self.navigationController pushViewController:detailViewController animated:YES];
    return;
}

@end
