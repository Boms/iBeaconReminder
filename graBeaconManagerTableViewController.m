//
//  graBeaconManagerTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/20/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graBeaconManagerTableViewController.h"
#import "updateNameViewController.h"
@interface graBeaconManagerTableViewController ()
@property (nonatomic, strong) iBeaconUser *myUser;
@property (nonatomic, strong) NSMutableArray *beaconArray;
@property (nonatomic, strong) NSMutableArray *namedBeacon;
@property (nonatomic, strong) NSMutableArray *unamedBeacon;
@property (nonatomic, strong) CLBeacon *lastFoundBeacon;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation graBeaconManagerTableViewController

-(void)enterEditMode
{
    [self.myUser stopMonitor];
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

-(void)exitEditMode
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.editButton;
    if ([self.namedBeacon count]) {
        [self.tableView reloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    for (NSDictionary *eachBeaconName in user.namesOfBeacon) {
        NSData *archieved = [eachBeaconName objectForKey:@"beacon"];
        CLBeacon *beacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
        [self.namedBeacon addObject:beacon];
    }
    
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(enterEditMode)];
    
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(enterEditMode)];
    self.navigationItem.rightBarButtonItem = trashButton;
    self.editButton = trashButton;
    
    UIBarButtonItem *doneItem =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(exitEditMode)];
    self.doneButton = doneItem;
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
        return [self.namedBeacon count];
    }
    else {
        return [self.unamedBeacon count];
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
    
    // Configure the cell...
    CLBeacon *thisOne = nil;
    if (indexPath.section == 0) {
        thisOne = self.namedBeacon[indexPath.row];
    }else{
        thisOne = self.unamedBeacon[indexPath.row];
    }
    iBeaconUser *user = [iBeaconUser sharedInstance];
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
    
    NSString *beaconLocaton = [user findNameByBeacon:thisOne];
    if (beaconLocaton) {
        cell.textLabel.text = beaconLocaton;
        cell.detailTextLabel.text = [uuid stringByAppendingString:distance];
    }else{
        cell.textLabel.text = @"起个名字吧";
        cell.detailTextLabel.text = [uuid stringByAppendingString:distance];
    }
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.section == 0) {
            CLBeacon *thisOne = nil;
            thisOne = self.namedBeacon[indexPath.row];
            iBeaconUser *user = [iBeaconUser sharedInstance];
            [user removeNameForBeacon:thisOne];
            [self.namedBeacon removeObjectAtIndex:indexPath.row];
            [user saveAllData];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
    CLBeacon *selectedBeacon = nil;
    if (indexPath.section == 0) {
        selectedBeacon = self.namedBeacon[indexPath.row];
    }
    if (indexPath.section == 1) {
        selectedBeacon = self.unamedBeacon[indexPath.row];
    }
    updateNameViewController *detailViewController = [[updateNameViewController alloc] initWithNibName:@"updateNameViewController" bundle:nil];
    detailViewController.myBeacon = selectedBeacon;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    detailViewController.nameChanged = ^(CLBeacon *nameChangedBeacon){
        NSInteger i =0;
        for (; i < [self.unamedBeacon count]; i++) {
            CLBeacon *eachUnamedBeacon = self.unamedBeacon[i];
            if ([user isBeacon:eachUnamedBeacon SameWith:nameChangedBeacon]) {
                [self.unamedBeacon removeObjectAtIndex:i];
                [self.tableView reloadData];
            }
        }
    };
    [self.navigationController pushViewController:detailViewController animated:YES];
    return;
}


@end
