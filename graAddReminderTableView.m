//
//  graAddReminderTableView.m
//  beaconReminderDemo
//
//  Created by li lin on 3/25/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graAddReminderTableView.h"

@interface graAddReminderTableView ()
@property (nonatomic, strong) UITextField *reminderTextField;
@property (nonatomic, strong) NSString *friends;
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
    return 2;
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
            cell.textLabel.text = @"标题";
            cell.textLabel.textColor = [UIColor purpleColor];
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
            
            titleField.tintColor = [UIColor redColor];
            titleField.returnKeyType = UIReturnKeyDone;
            [titleField setDelegate:self];
            UIToolbar *doneButtonbar = [[UIToolbar alloc] init];
            [doneButtonbar sizeToFit];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(okButtonAction)];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *inviteFriendsButton = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriendsButtonAction)];
            
            [doneButtonbar setItems:@[flexSpace, inviteFriendsButton, doneButton, cancelButton]];
            titleField.inputAccessoryView = doneButtonbar;
            
            //        titleField.borderStyle = UITextBorderStyleRoundedRect;
            self.reminderTextField = titleField;
            [cell.contentView addSubview:titleField];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    if (indexPath.row == 1) {
        CGRect cellBounds = cell.bounds;
        CGFloat textFieldBorder = 100;
        cell.textLabel.text = @"邀请朋友";
        cell.textLabel.textColor = [UIColor purpleColor];
        CGRect aRect = CGRectMake(textFieldBorder, 5.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
        UILabel *friendsLabel = [[UILabel alloc] initWithFrame:aRect];
        if (self.reminderDict) {
            friendsLabel.text = [self.reminderDict objectForKey:@"friends"];
            self.friends = friendsLabel.text;
        }
        [cell.contentView addSubview:friendsLabel];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
        [user AddRemindersWith:self.myBeacon with:self.reminderTextField.text friends:self.friends];
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
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
