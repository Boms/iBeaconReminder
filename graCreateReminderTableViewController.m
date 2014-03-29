//
//  graCreateReminderTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/21/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graCreateReminderTableViewController.h"
#import "graSelectBeaconTableViewController.h"
#import "colorForMarker.h"
#import "graSelectTimeTableViewController.h"
@interface graCreateReminderTableViewController ()
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *locationField;
@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) NSString *selectedBeaconName;
@property (nonatomic, strong) CLBeacon *selectedBeacon;
@property (nonatomic, strong) NSDictionary *selectedTimerDict;
@property (nonatomic, strong) NSString *selectedTimerString;
@property (nonatomic, strong) UILabel *selectedTimerLabel;
@property (nonatomic, strong) UILabel *selectedBeaconNameLabe;
@property (nonatomic, strong) UIPickerView* beaconPickerView;
@property (nonatomic, strong) NSMutableDictionary *reminderDict;

@property (nonatomic) NSInteger currentRowCount;
@end

@implementation graCreateReminderTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Cancel)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, saveBtn, flexSpace, cancelBtn, flexSpace];
    self.navigationController.toolbarHidden = NO;
    self.currentRowCount = 2;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if ([user.namesOfBeacon count] == 1) {
        NSDictionary *each = [user.namesOfBeacon objectAtIndex:0];
        NSData *archieved = [each objectForKey:@"beacon"];
        CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
        self.selectedBeacon = thisBeacon;
        self.selectedBeaconName = [each objectForKey:@"name"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.titleField.text isEqualToString:@""]) {
        [self.titleField becomeFirstResponder];
    }else{
        [self.tableView reloadData];
    }
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if (indexPath.row == 0) {
            
            CGRect cellBounds = cell.bounds;
            CGFloat textFieldBorder = 100;
            cell.textLabel.text = NSLocalizedString(@"WHAT", @"reminder title");
            cell.textLabel.textColor = [colorForMarker markerColor];
            CGFloat widthOfTextLabel = CGRectGetWidth(cell.textLabel.frame);
            // Don't align the field exactly in the vertical middle, as the text
            // is not actually in the middle of the field.
            CGRect aRect = CGRectMake(widthOfTextLabel + textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
            UITextField *titleField = [[UITextField alloc] initWithFrame:aRect];
            titleField.enablesReturnKeyAutomatically = YES;
            
            titleField.tintColor = [colorForMarker markerColor];
            titleField.returnKeyType = UIReturnKeyDone;
            [titleField setDelegate:self];
            
            //        titleField.borderStyle = UITextBorderStyleRoundedRect;
            self.titleField = titleField;
            [cell.contentView addSubview:titleField];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        if (indexPath.row == 2) {
            CGRect cellBounds = cell.bounds;
            CGFloat textFieldBorder = 100;
            cell.textLabel.text = NSLocalizedString(@"WHEN", @"the reminder timer");
            cell.textLabel.textColor = [colorForMarker markerColor];
            CGRect aRect = CGRectMake(textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
            UILabel *reminderTimer = [[UILabel alloc] initWithFrame:aRect];
            self.selectedTimerLabel = reminderTimer;
            reminderTimer.text = self.selectedTimerString;
            [cell.contentView addSubview:reminderTimer];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (indexPath.row == 1) {
            CGRect cellBounds = cell.bounds;
            CGFloat textFieldBorder = 100;
            cell.textLabel.text = NSLocalizedString(@"WHERE", @"which beacon is monitor");
            cell.textLabel.textColor = [colorForMarker markerColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CGRect aRect = CGRectMake(textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
            UILabel *selectedBeaconName = [[UILabel alloc] initWithFrame:aRect];
            self.selectedBeaconNameLabe = selectedBeaconName;
            selectedBeaconName.text = self.selectedBeaconName;
            [cell.contentView addSubview:selectedBeaconName];
        }
    }


    
    // Configure the cell...
    
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
     if (indexPath.row == 1) {
         graSelectBeaconTableViewController *detailViewController = [[graSelectBeaconTableViewController alloc] initWithNibName:@"graSelectBeaconTableViewController" bundle:nil];
         detailViewController.seletedBeacon = self.selectedBeacon;
         detailViewController.beaconSelected = ^(CLBeacon *thisBeacon){
             self.selectedBeacon = thisBeacon;
             iBeaconUser *user = [iBeaconUser sharedInstance];
             for (NSDictionary *each in user.namesOfBeacon) {
                 NSData *archieved = [each objectForKey:@"beacon"];
                 CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
                 NSString *beaconName = [each objectForKey:@"name"];
                 if ([user isBeacon:thisBeacon SameWith:self.selectedBeacon]) {
                     self.selectedBeaconName = beaconName;
                     self.selectedBeaconNameLabe.text = beaconName;
                     [self.tableView reloadData];
                 }
             }
         };
         
         // Pass the selected object to the new view controller.
         
         // Push the view controller.
         [self.navigationController pushViewController:detailViewController animated:YES];
     }
     if (indexPath.row == 2) {
         graSelectTimeTableViewController *vc = [[graSelectTimeTableViewController alloc]  initWithNibName:@"graSelectTimeTableViewController" bundle:nil];
         vc.reminderDict = self.reminderDict;
         vc.timerSelected = ^(NSDictionary *selectedTimer){
             if (self.reminderDict) {
                 NSMutableDictionary *fullInfo = self.reminderDict[@"fullInfo"];
                 if (fullInfo) {
                     [fullInfo setValue:selectedTimer forKey:@"timer"];
                 }else{
                     fullInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"timer":selectedTimer}];
                 }
                [self.reminderDict setValue:fullInfo forKey:@"fullInfo"];
             }else{
                 NSMutableDictionary *fullInfovalue  = [NSMutableDictionary dictionaryWithDictionary:@{@"timer":selectedTimer}];
                 _reminderDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:fullInfovalue, @"fullInfo", nil];
             }

             self.selectedTimerString = selectedTimer[@"textPresent"];
             self.selectedTimerLabel.text = self.selectedTimerString;
         };
         [self.navigationController pushViewController:vc animated:YES];

     }
 }



#pragma mark toolbar

-(void) Save
{
    if (self.titleField.text && ![self.titleField.text isEqualToString:@""] && self.selectedBeacon) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        if (self.reminderDict[@"fullInfo"]) {
            [user AddRemindersWith:self.selectedBeacon with:self.titleField.text withFullInfo:self.reminderDict[@"fullInfo"]];
        }else{
            [user AddRemindersWith:self.selectedBeacon with:self.titleField.text friends:@""];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)Cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
