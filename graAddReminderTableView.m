//
//  graAddReminderTableView.m
//  beaconReminderDemo
//
//  Created by li lin on 3/25/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graAddReminderTableView.h"
#import "colorForMarker.h"
#import "graSelectTimeTableViewController.h"
@interface graAddReminderTableView ()
@property (nonatomic, strong) UITextField *reminderTextField;
@property (nonatomic, strong) NSString *friends;
@property (nonatomic, strong) UILabel *selectTimeLabel;
@end

@implementation graAddReminderTableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashAction)];
    self.navigationController.toolbarHidden = YES;
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(okButtonAction)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, saveBtn, flexSpace, cancelBtn, flexSpace];
    self.navigationController.toolbarHidden = NO;
    
    
    iBeaconUser *user = [iBeaconUser sharedInstance];
    CLBeacon *thisOne = self.myBeacon;
    NSString *beaconLocaton = [user findNameByBeacon:thisOne];
    self.title =  [NSLocalizedString(@"AT", @"prefix word for location") stringByAppendingString:beaconLocaton];
    
    
    
    //http://stackoverflow.com/a/11876855/1412128
    NSData *buffer;
    // Deep copy "all" objects in _dict1 pointers and all to _dict2
    buffer = [NSKeyedArchiver archivedDataWithRootObject: self.reminderDict];
    self.reminderDictTemp = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
    //end of http://stackoverflow.com/a/11876855/1412128
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.reminderTextField.text isEqualToString:@""]) {
        [self.reminderTextField becomeFirstResponder];
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
            cell.textLabel.text = NSLocalizedString(@"WHAT", @"what to do");
            cell.textLabel.textColor = [colorForMarker markerColor];
            CGFloat widthOfTextLabel = CGRectGetWidth(cell.textLabel.frame);
            // Don't align the field exactly in the vertical middle, as the text
            // is not actually in the middle of the field.
            CGRect aRect = CGRectMake(widthOfTextLabel + textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder) - widthOfTextLabel, 31.f );
            UITextField *titleField = [[UITextField alloc] initWithFrame:aRect];
            if ([self.reminder isEqualToString:@""]) {
                titleField.placeholder = @"比如中午叫个外卖";
            }else{
                titleField.text = self.reminder;
            }
            titleField.enablesReturnKeyAutomatically = YES;
            
            titleField.tintColor = [colorForMarker markerColor];
            titleField.returnKeyType = UIReturnKeyDone;
            [titleField setDelegate:self];
#if 0
            UIToolbar *doneButtonbar = [[UIToolbar alloc] init];
            [doneButtonbar sizeToFit];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(okButtonAction)];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *inviteFriendsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"INVITE", @"invite others") style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriendsButtonAction)];
            
            [doneButtonbar setItems:@[flexSpace, inviteFriendsButton, doneButton, cancelButton]];
            titleField.inputAccessoryView = doneButtonbar;
#endif
            //        titleField.borderStyle = UITextBorderStyleRoundedRect;
            self.reminderTextField = titleField;
            [cell.contentView addSubview:titleField];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        if (indexPath.row == 2) {
            CGRect cellBounds = cell.bounds;
            CGFloat textFieldBorder = 100;
            cell.textLabel.text = NSLocalizedString(@"WHEN", @"effective timer for reminder");
            cell.textLabel.textColor = [colorForMarker markerColor];
            CGRect aRect = CGRectMake(textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
            UILabel *reminderTimer = [[UILabel alloc] initWithFrame:aRect];
            self.selectTimeLabel = reminderTimer;
            [cell.contentView addSubview:reminderTimer];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

    }
    if (indexPath.row == 1) {
        CGRect cellBounds = cell.bounds;
        CGFloat textFieldBorder = 100;
        cell.textLabel.text = NSLocalizedString(@"WHO", @"invited people");
        cell.textLabel.textColor = [colorForMarker markerColor];
        CGRect aRect = CGRectMake(textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
        UILabel *friendsLabel = [[UILabel alloc] initWithFrame:aRect];
        if (self.reminderDictTemp) {
            
            friendsLabel.text = [self.reminderDictTemp objectForKey:@"friends"];
            self.friends = friendsLabel.text;
            if (self.friends == nil) {
                self.friends = @"";
            }
        }
        [cell.contentView addSubview:friendsLabel];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.row == 2) {
        if (self.reminderDictTemp) {
            NSDictionary *fullInfo = self.reminderDictTemp[@"fullInfo"];
            if (fullInfo) {
                NSDictionary *reminderTimerInfo = fullInfo[@"timer"];
                if (reminderTimerInfo) {
                    NSString *reminderTimerInfoText = reminderTimerInfo[@"textPresent"];
                    self.selectTimeLabel.text = reminderTimerInfoText;
                }
            }else{
                self.selectTimeLabel.text = @"";
            }
        }
    }

    
    
    // Configure the cell...
    
    return cell;
}

-(void)removeMySelf
{
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if (self.reminder) {
        [user removeReminderWith:self.myBeacon with:self.reminder];
    }
}

-(void)trashAction
{
    [self removeMySelf];
    iBeaconUser *user = [iBeaconUser sharedInstance];
    NSMutableArray *reminderOfBeacon = [user findRemindersWith:self.myBeacon];
    if([reminderOfBeacon count] == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self cancelButtonAction];
    }
}

-(void)okButtonAction
{
    iBeaconUser *user = [iBeaconUser sharedInstance];
    
    if (self.reminderTextField.text && ![self.reminderTextField.text isEqualToString:@""]) {
        [self removeMySelf];
        if (self.reminderDictTemp[@"fullInfo"]) {
            [user AddRemindersWith:self.myBeacon with:self.reminderTextField.text withFullInfo:self.reminderDictTemp[@"fullInfo"]];
        }else{
            [user AddRemindersWith:self.myBeacon with:self.reminderTextField.text friends:self.friends];
        }

        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)cancelButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)inviteFriendsButtonAction
{
    //[self.friendsTextField becomeFirstResponder];
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
    if (indexPath.row == 0) {
        [self.reminderTextField becomeFirstResponder];
    }
    
    //select timer
    if (indexPath.row == 2) {
        graSelectTimeTableViewController *vc = [[graSelectTimeTableViewController alloc]  initWithNibName:@"graSelectTimeTableViewController" bundle:nil];
        vc.reminderDict = self.reminderDictTemp;
        vc.timerSelected = ^(NSDictionary *selectedTimer){
            NSDictionary *fullInfo = self.reminderDictTemp[@"fullInfo"];
            if (fullInfo) {
                [fullInfo setValue:selectedTimer forKey:@"timer"];
            }else{
                fullInfo =[NSMutableDictionary dictionaryWithDictionary:@{@"timer":selectedTimer}];
            }
            if (self.reminderDictTemp) {
                [self.reminderDictTemp setValue:fullInfo forKey:@"fullInfo"];
            }else{
                self.reminderDictTemp = [NSMutableDictionary dictionaryWithDictionary:@{@"fullInfo": fullInfo}];
            }

            [self.tableView reloadData];            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
